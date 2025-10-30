#!/usr/bin/env bash
##
##  nx - Node.js Environment Execution Utility
##  Copyright (c) 2025 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Licensed under MIT <https://spdx.org/licenses/MIT>
##

#   sanity check usage
if [[ $# -lt 2 ]]; then
    echo "nx: ERROR: invalid arguments (environment and command expected)" 1>&2
    echo "nx: USAGE: nx <env> create" 1>&2
    echo "nx: USAGE: nx <env> destroy" 1>&2
    echo "nx: USAGE: nx <env> <cmd> [...]" 1>&2
    exit 0
fi
env="$1"; shift

#   helper function for raising fatal error and terminate process
fatal () {
    echo "nx: ERROR: $*" 1>&2
    exit 1
}

#   dispatch according to command arguments
if [[ $env = "" ]]; then
    fatal "invalid empty environment"
fi
if [[ ! $env =~ ^[a-zA-Z0-9_-]+$ ]]; then
    fatal "invalid environment name (use only alphanumeric, minus, and underscore)"
fi
envdir="$HOME/.nx/$env"
case "$1" in
    create )
        #   create environment
        if [[ -d $envdir ]]; then
            fatal "environment \"$env\" already exists"
        fi
        echo "++ creating \"$envdir\""
        mkdir -p "$envdir/bin" "$envdir/lib/node_modules" || \
            fatal "failed to create environment directory"
        ;;

    destroy )
        #   destroy
        if [[ ! -d $envdir ]]; then
            fatal "environment \"$env\" does not exist"
        fi
        echo "++ destroying \"$envdir\""
        rm -rf "$envdir" || \
            fatal "failed to destroy environment directory"
        ;;

    * )
        export NPM_PREFIX="$envdir"
        export NPM_CONFIG_PREFIX="$envdir"
        export NODE_PATH="$envdir/lib/node_modules${NODE_PATH+:}${NODE_PATH}"
        export PATH="$envdir/bin${PATH+:}${PATH}"
        "$@"
        ;;
esac

