#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script to execute the Solidity tests.
#
# The documentation for solidity is hosted at:
#
#     https://solidity.readthedocs.org
#
# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016 solidity contributors.
#------------------------------------------------------------------------------

set -e

REPO_ROOT="$(dirname "$0")"/..

echo "Running commandline tests..."
"$REPO_ROOT/test/cmdlineTests.sh"

echo "Checking that StandardToken.sol, owned.sol and mortal.sol produce bytecode..."
output=$("$REPO_ROOT"/build/solc/solc --bin "$REPO_ROOT"/std/*.sol 2>/dev/null | grep "ffff" | wc -l)
test "${output//[[:blank:]]/}" = "3"

# This conditional is only needed because we don't have a working Homebrew
# install for `ele` at the time of writing, so we unzip the ZIP file locally
# instead.  This will go away soon.
if [[ "$OSTYPE" == "darwin"* ]]; then
    ELE_PATH="$REPO_ROOT/ele"
else
    ELE_PATH="ele"
fi

# This trailing ampersand directs the shell to run the command in the background,
# that is, it is forked and run in a separate sub-shell, as a job,
# asynchronously. The shell will immediately return the return status of 0 for
# true and continue as normal, either processing further commands in a script
# or returning the cursor focus back to the user in a Linux terminal.
$ELE_PATH --test -d /tmp/test &
ELE_PID=$!

# Wait until the IPC endpoint is available.  That won't be available instantly.
# The node needs to get a little way into its startup sequence before the IPC
# is available and is ready for the unit-tests to start talking to it.
while [ ! -S /tmp/test/gele.ipc ]; do sleep 2; done
echo "--> IPC available."
sleep 2
# And then run the Solidity unit-tests (once without optimization, once with),
# pointing to that IPC endpoint.
echo "--> Running tests without optimizer..."
  "$REPO_ROOT"/build/test/soltest --show-progress -- --ipcpath /tmp/test/gele.ipc && \
  echo "--> Running tests WITH optimizer..." && \
  "$REPO_ROOT"/build/test/soltest --show-progress -- --optimize --ipcpath /tmp/test/gele.ipc
ERROR_CODE=$?
pkill "$ELE_PID" || true
sleep 4
pgrep "$ELE_PID" && pkill -9 "$ELE_PID" || true
exit $ERROR_CODE
