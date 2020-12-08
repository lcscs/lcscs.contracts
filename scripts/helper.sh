# Ensures passed in version values are supported.
function check-version-numbers() {
  CHECK_VERSION_MAJOR=$1
  CHECK_VERSION_MINOR=$2

  if [[ $CHECK_VERSION_MAJOR -lt $lcscs_MIN_VERSION_MAJOR ]]; then
    exit 1
  fi
  if [[ $CHECK_VERSION_MAJOR -gt $lcscs_MAX_VERSION_MAJOR ]]; then
    exit 1
  fi
  if [[ $CHECK_VERSION_MAJOR -eq $lcscs_MIN_VERSION_MAJOR ]]; then
    if [[ $CHECK_VERSION_MINOR -lt $lcscs_MIN_VERSION_MINOR ]]; then
      exit 1
    fi
  fi
  if [[ $CHECK_VERSION_MAJOR -eq $lcscs_MAX_VERSION_MAJOR ]]; then
    if [[ $CHECK_VERSION_MINOR -gt $lcscs_MAX_VERSION_MINOR ]]; then
      exit 1
    fi
  fi
  exit 0
}


# Handles choosing which lcscs directory to select when the default location is used.
function default-lcscs-directories() {
  REGEX='^[0-9]+([.][0-9]+)?$'
  ALL_lcscs_SUBDIRS=()
  if [[ -d ${HOME}/lcscs ]]; then
    ALL_lcscs_SUBDIRS=($(ls ${HOME}/lcscs | sort -V))
  fi
  for ITEM in "${ALL_lcscs_SUBDIRS[@]}"; do
    if [[ "$ITEM" =~ $REGEX ]]; then
      DIR_MAJOR=$(echo $ITEM | cut -f1 -d '.')
      DIR_MINOR=$(echo $ITEM | cut -f2 -d '.')
      if $(check-version-numbers $DIR_MAJOR $DIR_MINOR); then
        PROMPT_lcscs_DIRS+=($ITEM)
      fi
    fi
  done
  for ITEM in "${PROMPT_lcscs_DIRS[@]}"; do
    if [[ "$ITEM" =~ $REGEX ]]; then
      lcscs_VERSION=$ITEM
    fi
  done
}


# Prompts or sets default behavior for choosing lcscs directory.
function lcscs-directory-prompt() {
  if [[ -z $lcscs_DIR_PROMPT ]]; then
    default-lcscs-directories;
    echo 'No lcscs location was specified.'
    while true; do
      if [[ $NONINTERACTIVE != true ]]; then
        if [[ -z $lcscs_VERSION ]]; then
          echo "No default lcscs installations detected..."
          PROCEED=n
        else
          printf "Is lcscs installed in the default location: $HOME/lcscs/$lcscs_VERSION (y/n)" && read -p " " PROCEED
        fi
      fi
      echo ""
      case $PROCEED in
        "" )
          echo "Is lcscs installed in the default location?";;
        0 | true | [Yy]* )
          break;;
        1 | false | [Nn]* )
          if [[ $PROMPT_lcscs_DIRS ]]; then
            echo "Found these compatible lcscs versions in the default location."
            printf "$HOME/lcscs/%s\n" "${PROMPT_lcscs_DIRS[@]}"
          fi
          printf "Enter the installation location of lcscs:" && read -e -p " " lcscs_DIR_PROMPT;
          lcscs_DIR_PROMPT="${lcscs_DIR_PROMPT/#\~/$HOME}"
          break;;
        * )
          echo "Please type 'y' for yes or 'n' for no.";;
      esac
    done
  fi
  export lcscs_INSTALL_DIR="${lcscs_DIR_PROMPT:-${HOME}/lcscs/${lcscs_VERSION}}"
}


# Prompts or default behavior for choosing lcscs.CDT directory.
function cdt-directory-prompt() {
  if [[ -z $CDT_DIR_PROMPT ]]; then
    echo 'No lcscs.CDT location was specified.'
    while true; do
      if [[ $NONINTERACTIVE != true ]]; then
        printf "Is lcscs.CDT installed in the default location? /usr/local/lcscs.cdt (y/n)" && read -p " " PROCEED
      fi
      echo ""
      case $PROCEED in
        "" )
          echo "Is lcscs.CDT installed in the default location?";;
        0 | true | [Yy]* )
          break;;
        1 | false | [Nn]* )
          printf "Enter the installation location of lcscs.CDT:" && read -e -p " " CDT_DIR_PROMPT;
          CDT_DIR_PROMPT="${CDT_DIR_PROMPT/#\~/$HOME}"
          break;;
        * )
          echo "Please type 'y' for yes or 'n' for no.";;
      esac
    done
  fi
  export CDT_INSTALL_DIR="${CDT_DIR_PROMPT:-/usr/local/lcscs.cdt}"
}


# Ensures lcscs is installed and compatible via version listed in tests/CMakeLists.txt.
function nodscs-version-check() {
  INSTALLED_VERSION=$(echo $($lcscs_INSTALL_DIR/bin/nodscs --version))
  INSTALLED_VERSION_MAJOR=$(echo $INSTALLED_VERSION | cut -f1 -d '.' | sed 's/v//g')
  INSTALLED_VERSION_MINOR=$(echo $INSTALLED_VERSION | cut -f2 -d '.' | sed 's/v//g')

  if [[ -z $INSTALLED_VERSION_MAJOR || -z $INSTALLED_VERSION_MINOR ]]; then
    echo "Could not determine lcscs version. Exiting..."
    exit 1;
  fi

  if $(check-version-numbers $INSTALLED_VERSION_MAJOR $INSTALLED_VERSION_MINOR); then
    if [[ $INSTALLED_VERSION_MAJOR -gt $lcscs_SOFT_MAX_MAJOR ]]; then
      echo "Detected lcscs version is greater than recommended soft max: $lcscs_SOFT_MAX_MAJOR.$lcscs_SOFT_MAX_MINOR. Proceed with caution."
    fi
    if [[ $INSTALLED_VERSION_MAJOR -eq $lcscs_SOFT_MAX_MAJOR && $INSTALLED_VERSION_MINOR -gt $lcscs_SOFT_MAX_MINOR ]]; then
      echo "Detected lcscs version is greater than recommended soft max: $lcscs_SOFT_MAX_MAJOR.$lcscs_SOFT_MAX_MINOR. Proceed with caution."
    fi
  else
    echo "Supported versions are: $lcscs_MIN_VERSION_MAJOR.$lcscs_MIN_VERSION_MINOR - $lcscs_MAX_VERSION_MAJOR.$lcscs_MAX_VERSION_MINOR"
    echo "Invalid lcscs installation. Exiting..."
    exit 1;
  fi
}
