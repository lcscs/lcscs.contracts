#!/bin/bash
set -e # exit on failure of any "simple" command (excludes &&, ||, or | chains)
# expected places to find lcscs CMAKE in the docker container, in ascending order of preference
[[ -e /usr/lib/lcscs/lib/cmake/lcscs/lcscs-config.cmake ]] && export CMAKE_FRAMEWORK_PATH="/usr/lib/lcscs"
[[ -e /opt/lcscs/lib/cmake/lcscs/lcscs-config.cmake ]] && export CMAKE_FRAMEWORK_PATH="/opt/lcscs"
[[ ! -z "$lcscs_ROOT" && -e $lcscs_ROOT/lib/cmake/lcscs/lcscs-config.cmake ]] && export CMAKE_FRAMEWORK_PATH="$lcscs_ROOT"
# fail if we didn't find it
[[ -z "$CMAKE_FRAMEWORK_PATH" ]] && exit 1
# export variables
echo "" >> /lcscs.contracts/docker/environment.Dockerfile # necessary if there is no '\n' at end of file
echo "ENV CMAKE_FRAMEWORK_PATH=$CMAKE_FRAMEWORK_PATH" >> /lcscs.contracts/docker/environment.Dockerfile
echo "ENV lcscs_ROOT=$CMAKE_FRAMEWORK_PATH" >> /lcscs.contracts/docker/environment.Dockerfile