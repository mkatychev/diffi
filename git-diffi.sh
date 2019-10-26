#!/usr/bin/env bash

# set -x
_git_root=$(git rev-parse --show-toplevel)

test -f "$_git_root/.diffignore" || \
    cp "./$_git_root/.diffignore.base" "./$_git_root/.diffignore" >& /dev/null || \
    >&2 echo "diffignore: no .diffignore or .diffignore.base found in root git directory!"|| exit 1

PATHS=""
VALID_ARGS=""

while (( "$#" )); do
    # swallow double dash since we will append it anyways
    if [[ "$1" == "--" ]]; then
        continue
    # determine valid glob patterns also checks existence of strict path
    elif [[ $(compgen -G "$1") ]]; then
        PATHS+=" $1"
    else
        VALID_ARGS+=" $1"
    fi
shift
done




# https://git-scm.com/docs/gitignore#_pattern_format
DIFFI=""



while read -r ignore;do
    if [ -n "$ignore" ] && [[ "${ignore}" != \!* ]] && [[ "$ignore" != \#* ]] ;
    then
        DIFFI+=" :!${ignore}"
    fi
done < "$_git_root/.diffignore"



# git diff "$@" -- $(scripts/diffignore.sh)
echo "$VALID_ARGS -- $(realpath -z $PATHS)$DIFFI"
