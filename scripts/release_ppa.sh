#!/usr/bin/env bash
##############################################################################
## This is used to package .deb packages and upload them to the launchpad
## ppa servers for building.
##
## If no argument is given, creates a package for the develop branch
## and uploads it to the elementrem/elementrem-dev ppa.
##
## If an argument is given, it is used as a tag and the resulting package
## is uploaded to the elementrem/elementrem ppa.
##
## The gnupg key for "builds@elementrem.org" has to be present in order to sign
## the package.
##
## It will clone the Solidity git from github, determine the version,
## create a source archive and push it to the ubuntu ppa servers.
##
##############################################################################

set -ev

if [ -z "$1" ]
then
    branch=develop
else
    branch=$1
fi

if [ "$branch" = develop ]
then
    pparepo=elementrem/elementrem-dev
    ppafilesurl=https://launchpad.net/~elementrem/+archive/ubuntu/elementrem-dev/+files
else
    pparepo=elementrem/elementrem
    ppafilesurl=https://launchpad.net/~elementrem/+archive/ubuntu/elementrem/+files
fi

keyid=703F83D0
email=builds@elementrem.org
packagename=solc

for distribution in trusty vivid wily xenial yakkety
do
cd /tmp/
mkdir $distribution
cd $distribution

# Fetch source
git clone --recursive https://github.com/elementrem/solidity.git -b "$branch"
mv solidity solc

# Determine version
cd solc
version=`grep -oP "PROJECT_VERSION \"?\K[0-9.]+(?=\")"? CMakeLists.txt`
commithash=`git rev-parse --short HEAD`
committimestamp=`git show --format=%ci HEAD | head -n 1`
commitdate=`git show --format=%ci HEAD | head -n 1 | cut - -b1-10`

# TODO store the commit hash in a file so that the build info mechanism can pick it up even without git

if [ $branch = develop ]
then
    debversion="$version-nightly-$commitdate-$commithash"
else
    debversion="$version"
fi

# gzip will create different tars all the time and we are not allowed
# to upload the same file twice with different contents, so we only
# create it once.
if [ ! -e /tmp/${packagename}_${debversion}.orig.tar.gz ]
then
    tar --exclude .git -czf /tmp/${packagename}_${debversion}.orig.tar.gz .
fi
cp /tmp/${packagename}_${debversion}.orig.tar.gz ../

# Create debian package information

case $distribution in
    trusty)
        jsoncpplib=libjsoncpp0
        ;;
    vivid)
        jsoncpplib=libjsoncpp0
        ;;
    wily)
        jsoncpplib=libjsoncpp0v5
        ;;
    *)
        jsoncpplib=libjsoncpp1
        ;;
esac

mkdir debian
echo 9 > debian/compat
cat <<EOF > debian/control
Source: solc
Section: science
Priority: extra
Maintainer: Christian (Buildserver key) <builds@elementrem.org>
Build-Depends: debhelper (>= 9.0.0),
               libcryptopp-dev,
               cmake,
               g++-4.8,
               git,
               libgmp-dev,
               libboost-all-dev,
               automake,
               libtool,
               scons,
               libjsoncpp-dev
Standards-Version: 3.9.5
Homepage: https://elementrem.org
Vcs-Git: git://github.com/elementrem/solidity.git
Vcs-Browser: https://github.com/elementrem/solidity

Package: solc
Architecture: any-i386 any-amd64
Multi-Arch: same
Depends: \${shlibs:Depends}, \${misc:Depends}, $jsoncpplib
Replaces: lllc (<< 1:0.3.6)
Conflicts: libelementrem (<= 1.2.9)
Description: Solidity compiler.
 The commandline interface to the Solidity smart contract compiler.
EOF
cat <<EOF > debian/rules
#!/usr/bin/make -f
# -*- makefile -*-
# Sample debian/rules that uses debhelper.
#
# This file was originally written by Joey Hess and Craig Small.
# As a special exception, when this file is copied by dh-make into a
# dh-make output file, you may use that output file without restriction.
# This special exception was added by Craig Small in version 0.37 of dh-make.
#
# Modified to make a template file for a multi-binary package with separated
# build-arch and build-indep targets  by Bill Allombert 2001

# Uncomment this to turn on verbose mode.
export DH_VERBOSE=1

# This has to be exported to make some magic below work.
export DH_OPTIONS


%:
	dh \$@ --buildsystem=cmake #--with sphinxdoc

override_dh_auto_test:

#override_dh_installdocs:
#	make -C docs html
#	dh_installdocs docs/_build/html

override_dh_shlibdeps:
	dh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info
EOF
cat <<EOF > debian/copyright
Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: solc
Source: https://github.com/elementrem/solidity

Files: *
Copyright: 2016 Elementrem
License: GPL-3.0+

Files: debian/*
Copyright: 2016 Elementrem
License: GPL-3.0+

License: GPL-3.0+
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 .
 This package is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 .
 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.
 .
 On Debian systems, the complete text of the GNU General
 Public License version 3 can be found in "/usr/share/common-licenses/GPL-3".
EOF
cat <<EOF > debian/changelog
solc (0.0.1-0ubuntu1) saucy; urgency=low

  * Initial release.

 -- Christian <build@elementrem.org>  Mon, 03 Feb 2016 14:50:20 +0000
EOF
echo docs > debian/docs
mkdir debian/source
echo "3.0 (quilt)" > debian/source/format
chmod +x debian/rules

versionsuffix=0ubuntu1~${distribution}
# bump version / add entry to changelog
EMAIL="$email" dch -v 1:${debversion}-${versionsuffix} "git build of ${commithash}"


# build source package
# If packages is rejected because original source is already present, add
# -sd to remove it from the .changes file
debuild -S -sa -us -uc

# prepare .changes file for Launchpad
sed -i -e s/UNRELEASED/${distribution}/ -e s/urgency=medium/urgency=low/ ../*.changes

# check if ubuntu already has the source tarball
(
cd ..
orig=${packagename}_${debversion}.orig.tar.gz
orig_size=$(ls -l $orig | cut -d ' ' -f 5)
orig_sha1=$(sha1sum $orig | cut -d ' ' -f 1)
orig_sha256=$(sha256sum $orig | cut -d ' ' -f 1)
orig_md5=$(md5sum $orig | cut -d ' ' -f 1)

if wget --quiet -O $orig-tmp "$ppafilesurl/$orig"
then
    echo "[WARN] Original tarball found in Ubuntu archive, using it instead"
    mv $orig-tmp $orig
    new_size=$(ls -l *.orig.tar.gz | cut -d ' ' -f 5)
    new_sha1=$(sha1sum $orig | cut -d ' ' -f 1)
    new_sha256=$(sha256sum $orig | cut -d ' ' -f 1)
    new_md5=$(md5sum $orig | cut -d ' ' -f 1)
    sed -i -e s,$orig_sha1,$new_sha1,g -e s,$orig_sha256,$new_sha256,g -e s,$orig_size,$new_size,g -e s,$orig_md5,$new_md5,g *.dsc
    sed -i -e s,$orig_sha1,$new_sha1,g -e s,$orig_sha256,$new_sha256,g -e s,$orig_size,$new_size,g -e s,$orig_md5,$new_md5,g *.changes
fi
)

# sign the package
debsign --re-sign -k ${keyid} ../${packagename}_${debversion}-${versionsuffix}_source.changes

# upload
dput ppa:${pparepo} ../${packagename}_${debversion}-${versionsuffix}_source.changes

done