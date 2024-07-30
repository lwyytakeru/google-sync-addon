#!/usr/bin/env bash
# SPDX-FileCopyrightText: (c) 2016 ale5000
# SPDX-License-Identifier: GPL-3.0-or-later

# shellcheck enable=all

set -u
# shellcheck disable=SC3040,SC3041,SC2015 # Ignore: In POSIX sh, set option xxx is undefined. / In POSIX sh, set flag -X is undefined. / C may run when A is true.
{
  # Unsupported set options may cause the shell to exit (even without set -e), so first try them in a subshell to avoid this issue
  (set 2> /dev/null -o posix) && set -o posix || true
  (set 2> /dev/null +H) && set +H || true
  (set 2> /dev/null -o pipefail) && set -o pipefail || true
}

if test "${A5K_FUNCTIONS_INCLUDED:-false}" = 'false'; then
  if test -e '/usr/bin'; then PATH="/usr/bin:${PATH-}"; fi

  if test -z "${MAIN_DIR-}"; then
    # shellcheck disable=SC3028 # Ignore: In POSIX sh, BASH_SOURCE is undefined.
    if test -n "${BASH_SOURCE-}" && MAIN_DIR="$(dirname "${BASH_SOURCE:?}")" && MAIN_DIR="$(realpath "${MAIN_DIR:?}")"; then
      export MAIN_DIR
    else
      unset MAIN_DIR
    fi
  fi

  if test -n "${MAIN_DIR-}" && test -z "${USER_HOME-}"; then
    if test "${TERM_PROGRAM-}" = 'mintty'; then unset TERM_PROGRAM; fi
    export USER_HOME="${HOME-}"
    export HOME="${MAIN_DIR:?}"
  fi

  unset STARTED_FROM_BATCH_FILE
  unset IS_PATH_INITIALIZED
  export DO_INIT_CMDLINE=1

  if test -n "${MAIN_DIR-}"; then
    exec bash --init-file "${MAIN_DIR:?}/includes/common.sh"
  else
    exec bash --init-file './includes/common.sh'
  fi
fi
