#!/usr/bin/env bash

# git config --global alias.diffi '!git diff'
_git_root=$(git rev-parse --show-toplevel)

test -f "$_git_root/.diffignore" || \
    cp "./$_git_root/.diffignore.base" "./$_git_root/.diffignore" >& /dev/null || \
    >&2 echo "git-diffi: no .diffignore or .diffignore.base found in root git directory!"|| exit 1

PATHS=()
VALID_ARGS=()

while (( "$#" )); do
    # swallow double dash since we will append it anyways
    if [[ "$1" == "--" ]]; then
        continue
    # determine valid glob patterns also checks existence of strict path
    elif [[ $(compgen -G "$1") ]]; then
        PATHS+=("$1")
    else
        VALID_ARGS+=("$1")
    fi
shift
done

# https://git-scm.com/docs/gitignore#_pattern_format
DIFFI=()

# read from .diffibnore file
while read -r ignore;do
    if [ -n "$ignore" ] && [[ "${ignore}" != \!* ]] && [[ "$ignore" != \#* ]] ;
    then
        DIFFI+=(":!${ignore}")
    fi
done < "$_git_root/.diffignore"



[[ -n "$PATHS" ]] && REAL_PATHS=$(realpath --relative-to=$_git_root ${PATHS[@]})
# execute git diff from repo root so that diffignore is applied properly
# keeping provided direct paths
(cd $_git_root; \
    git diff $(echo "${VALID_ARGS[@]} --  ${REAL_PATHS:-} ${DIFFI[@]}"))
