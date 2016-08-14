Ubuntu Xenial (16.04)
```
//Prerequisite
git clone --recursive https://github.com/elementrem/solidity.git
sudo apt-get -y install build-essential git cmake libgmp-dev libboost-all-dev \
    libjsoncpp-dev

sudo apt-get -y install ubuntu-dev-tools
sudo pbuilder create
cd solidity/dependency/ubuntu_1604
sudo dpkg -i libcryptopp-dev_5.6.2+0wily-0ubuntu1_amd64.deb
//build
cd ../..
mkdir build
cd build
cmake .. && make
```
