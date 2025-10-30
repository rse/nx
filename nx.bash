#!/usr/bin/env bash
##
##  nx - Node.js Environment Execution Utility
##  Copyright (c) 2025 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Licensed under MIT <https://spdx.org/licenses/MIT>
##

#   use sane environment
set -o errexit -o pipefail

#   sanity check usage
if [[ $# -lt 2 ]]; then
    echo "nx: ERROR: invalid arguments (environment and command expected)" 1>&2
    echo "nx: USAGE: nx <env> --create" 1>&2
    echo "nx: USAGE: nx <env> --destroy" 1>&2
    echo "nx: USAGE: nx <env> --list" 1>&2
    echo "nx: USAGE: nx <env> --update" 1>&2
    echo "nx: USAGE: nx <env> <cmd> [...]" 1>&2
    exit 1
fi

#   helper function for raising fatal error and terminate process
fatal () {
    echo "nx: ERROR: $*" 1>&2
    exit 1
}

#   determine environment directory
env="$1"; shift
if [[ -z $env ]]; then
    fatal "invalid empty environment"
fi
if [[ ! $env =~ ^[a-zA-Z0-9_-]+$ ]]; then
    fatal "invalid environment name (use only alphanumeric, minus, and underscore)"
fi
envdir="$HOME/.nx/$env"

#   helper function for setting up environment
mkenv () {
    export NPM_PREFIX="$envdir"
    export NPM_CONFIG_PREFIX="$envdir"
    export NODE_PATH="$envdir/lib/node_modules${NODE_PATH+:}${NODE_PATH}"
    export PATH="$envdir/bin${PATH+:}${PATH}"
}

#   helper function for extracting package name
npm_pkg_name () {
    local entry="$1"
    echo "$entry" | sed -e 's;^[^:]*:;;' -e 's;^\(..*\)@\(..*\);-\1;' -e 's;^[^-].*;;' -e 's;^-;;'
}

#   helper function for determining package version
npm_pkg_version () {
    npm list -g --depth 0 "$1" 2>/dev/null | grep -F "$1@" | sed "s/.*@//"
}

#   dispatch according to command arguments
case "$1" in
    --create )
        #   create environment
        if [[ -d $envdir ]]; then
            fatal "environment \"$env\" already exists"
        fi
        echo "++ creating \"$envdir\""
        mkdir -p "$envdir/bin" "$envdir/lib/node_modules" || \
            fatal "failed to create environment directory"
        ;;

    --destroy )
        #   destroy environment
        if [[ ! -d $envdir ]]; then
            fatal "environment \"$env\" does not exist"
        fi
        if [[ ! $envdir =~ /.nx/ ]]; then
            fatal "refusing to destroy directory outside .nx namespace"
        fi
        echo "++ destroying \"$envdir\""
        rm -rf "$envdir" || \
            fatal "failed to destroy environment directory"
        ;;

    --list )
        #   list NPM packages
        if [[ ! -d $envdir ]]; then
            fatal "environment \"$env\" does not exist"
        fi

        #   for all installed NPM packages...
        mkenv
        while IFS= read -r pkg_entry; do
            pkg=$(npm_pkg_name "$pkg_entry")
            if [[ -n $pkg ]]; then
                #   ...determine versions...
                version=$(npm_pkg_version "$pkg")
                echo "nx: INFO: package $pkg $version"
            fi
        done < <(npm list -g --depth 0 -p -l)
        ;;

    --update )
        #   update NPM packages
        if [[ ! -d $envdir ]]; then
            fatal "environment \"$env\" does not exist"
        fi

        #   for all installed NPM packages...
        mkenv
        while IFS= read -r pkg_entry; do
            pkg=$(npm_pkg_name "$pkg_entry")
            if [[ -n $pkg ]]; then
                #   ...determine versions...
                version_old=$(npm_pkg_version "$pkg")
                version_new=$(npm show "$pkg" version 2>/dev/null)
                if [[ -z "$version_new" ]]; then
                    fatal "failed to determine version for NPM package: $pkg"
                fi

                #   ...and either update or keep it
                if [[ $version_old != $version_new ]]; then
                    echo "nx: INFO: package $pkg $version_old -- updating to $version_new"
                    npm install --quiet --silent -y -g "$pkg@$version_new" || \
                        fatal "failed to update NPM package: $pkg@$version_new"
                else
                    echo "nx: INFO: package $pkg $version_old -- still up-to-date"
                fi
            fi
        done < <(npm list -g --depth 0 -p -l)
        ;;

    * )
        mkenv
        "$@"
        ;;
esac

