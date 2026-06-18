ORIG_DIR="$(pwd)"
cd "$(dirname "$0")/../.."
BASE_DIR="$(pwd)"

CI_NODEJS_AUTOINSTALL_DIR="$BASE_DIR/cicd/tmp/nodejs-autoinstall"
PREPARE_POSTINSTALL_SCRIPT="$BASE_DIR/cicd/tmp/well-known/set-env/post-prepare-autoinstall.sh"

__CI_COMMON_STEP_COUNT=1

step () {
  printf "\n\n============================================================================\n"
  printf 'STEP #%d: %s\n' "$STEP_COUNT" "$1"
  printf "\n============================================================================\n\n"
  _CI_COMMON_STEP_COUNT="$((STEP_COUNT + 1))"
}

mktempdir () {
  # TODO: Provide a POSIX-compliant fallback
  printf '%s' "$(mktemp -d)"
}
