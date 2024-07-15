#!/usr/bin/env bash
# SPDX-FileCopyrightText: (c) 2016 ale5000
# SPDX-License-Identifier: GPL-3.0-or-later

# shellcheck enable=all

set -u
# shellcheck disable=SC3040,SC3041,SC2015
{
  # Unsupported set options may cause the shell to exit (even without set -e), so first try them in a subshell to avoid this issue
  (set -o posix 2> /dev/null) && set -o posix || true
  (set +H 2> /dev/null) && set +H || true
  (set -o pipefail 2> /dev/null) && set -o pipefail || true
}

if test "${A5K_FUNCTIONS_INCLUDED:-false}" = 'false'; then
  unset STARTED_FROM_BATCH_FILE
  unset IS_PATH_INITIALIZED
  unset TERM_PROGRAM

  if test -z "${SCRIPT_DIR-}"; then
    # shellcheck disable=SC3028 # Ignore: In POSIX sh, BASH_SOURCE is undefined.
    if test -n "${BASH_SOURCE-}" && SCRIPT_DIR="$(dirname "${BASH_SOURCE:?}")" && SCRIPT_DIR="$(realpath "${SCRIPT_DIR:?}")"; then
      export SCRIPT_DIR
    else
      unset SCRIPT_DIR
    fi
  fi

  if test -n "${SCRIPT_DIR-}"; then
    HOME="${SCRIPT_DIR:?}"
    export HOME
  fi

  DO_INIT_CMDLINE=1 bash --init-file './includes/common.sh'
fi
