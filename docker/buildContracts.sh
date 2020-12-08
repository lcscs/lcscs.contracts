#!/bin/bash
set -e # exit on failure of any "simple" command (excludes &&, ||, or | chains)
cd /lcscs.contracts
./build.sh -c /usr/opt/lcscs.cdt -e /opt/lcscs -t -y
cd build
tar -pczf /artifacts/contracts.tar.gz *
