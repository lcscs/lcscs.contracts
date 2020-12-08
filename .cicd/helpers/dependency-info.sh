#!/bin/bash
set -eo pipefail
[[ "$RAW_PIPELINE_CONFIG" == '' ]] && export RAW_PIPELINE_CONFIG="$1"
[[ "$RAW_PIPELINE_CONFIG" == '' ]] && export RAW_PIPELINE_CONFIG='pipeline.jsonc'
[[ "$PIPELINE_CONFIG" == '' ]] && export PIPELINE_CONFIG='pipeline.json'
# read dependency file
if [[ -f "$RAW_PIPELINE_CONFIG" ]]; then
    echo 'Reading pipeline configuration file...'
    cat "$RAW_PIPELINE_CONFIG" | grep -Po '^[^"/]*("((?<=\\).|[^"])*"[^"/]*)*' | jq -c .\"lcscs-dot-contracts\" > "$PIPELINE_CONFIG"
    CDT_VERSION=$(cat "$PIPELINE_CONFIG" | jq -r '.dependencies."lcscs.cdt"')
    lcscs_VERSION=$(cat "$PIPELINE_CONFIG" | jq -r '.dependencies.lcscs')
else
    echo 'ERROR: No pipeline configuration file or dependencies file found!'
    exit 1
fi
# search GitHub for commit hash by tag and branch, preferring tag if both match
if [[ "$BUILDKITE" == 'true' ]]; then
    CDT_COMMIT=$((curl -s https://api.github.com/repos/lcscs/lcscs.cdt/git/refs/tags/$CDT_VERSION && curl -s https://api.github.com/repos/lcscs/lcscs.cdt/git/refs/heads/$CDT_VERSION) | jq '.object.sha' | sed "s/null//g" | sed "/^$/d" | tr -d '"' | sed -n '1p')
    lcscs_COMMIT=$((curl -s https://api.github.com/repos/lcscs/scs/git/refs/tags/$lcscs_VERSION && curl -s https://api.github.com/repos/lcscs/scs/git/refs/heads/$lcscs_VERSION) | jq '.object.sha' | sed "s/null//g" | sed "/^$/d" | tr -d '"' | sed -n '1p')
    test -z "$CDT_COMMIT" && CDT_COMMIT=$(echo $CDT_VERSION | tr -d '"' | tr -d "''" | cut -d ' ' -f 1) # if both searches returned nothing, the version is probably specified by commit hash already
    test -z "$lcscs_COMMIT" && lcscs_COMMIT=$(echo $lcscs_VERSION | tr -d '"' | tr -d "''" | cut -d ' ' -f 1) # if both searches returned nothing, the version is probably specified by commit hash already
else
    git clone https://github.com/lcscs/lcscs.cdt && cd lcscs.cdt
    git pull && git checkout $CDT_VERSION
    CDT_COMMIT=$(git rev-parse --verify HEAD)
    cd ..
    git clone https://github.com/lcscs/scs && cd scs
    git pull && git checkout $lcscs_VERSION
    lcscs_COMMIT=$(git rev-parse --verify HEAD)
    cd ..
fi
echo "Using lcscs ${lcscs_COMMIT:0:7} from \"$lcscs_VERSION\"..."
echo "Using cdt ${CDT_COMMIT:0:7} from \"$CDT_VERSION\"..."
export CDT_URL="https://scs-public-oss-binaries.s3-us-west-2.amazonaws.com/${CDT_COMMIT:0:7}-lcscs.cdt-ubuntu-18.04_amd64.deb"