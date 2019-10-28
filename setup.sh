#!/bin/sh

set -e

DIFFI_GLOBAL=${DIFFI_GLOBAL:-~/.diffignore.global}
# Only use colors if connected to a terminal
if [ -t 1 ]; then
    GREEN=$(printf '\033[32m')
    RED=$(printf '\033[31m')
    RESET=$(printf '\033[m')
    YELLOW=$(printf '\033[33m')
else
    GREEN=""
    RED=""
    RESET=""
    YELLOW=""
fi

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error: $@"${RESET} >&2
}


check_git() {
    command_exists git || {
		error "git is not installed!"
		exit 1
    }
}

Y_n="${YELLOW}[${RESET}Y${YELLOW}/${RESET}n${YELLOW}]${RESET}"

alias_diffi() {
    printf "${YELLOW}Do you want git-diffi to use git diff autocompletion? $Y_n "
    read opt
    case $opt in
        y*|Y*|"") echo "Adding autocompletion to git-diffi." ;;
        n*|N*) echo "Aliasing skipped."; completion_doc; return ;;
        *) echo "Invalid choice. Aliasing aborted."; return ;;
    esac
    git config --global alias.diffi '!git diff'
}

completion_doc() {
cat << EOF

git-diffi can be configured to use git diff autocompletion with this command:
    $ git config --global alias.diffi '!git diff'

EOF
}

global_diffi_doc() {
    cat << EOF

You can create a .diffignore/.diffignore.base in any git project by calling:
    $ git diffi --init
    $ git diffi --init-base
respectively.

This will copy to the contents of the filepath set by the ${YELLOW}\$DIFFI_GLOBAL${RESET} variable (~/.diffignore.global by default).

EOF
}


cp_global() {
    printf "${YELLOW}Do you want to create a ${GREEN}.diffignore.global${YELLOW}? $Y_n "
    read opt
    case $opt in
        y*|Y*|"") echo "Creating global diffignore" ;;
        n*|N*) echo "Global diffignore skipped.";  global_diffi_doc; return ;;
        *) echo "Invalid choice. Aliasing aborted."; return ;;
    esac
    cp -n "$PWD/.diffignore.global" "$DIFFI_GLOBAL" || {
        error "$DIFFI_GLOBAL already exists!" 
        exit 1
    }

    global_diffi_doc 

    echo "${GREEN}$DIFFI_GLOBAL:${RESET}"
    cat "$DIFFI_GLOBAL"
}


ln_or_cp() {
    printf "${YELLOW}Do you want to sym[${RESET}L${YELLOW}]ink, "
    printf "[${RESET}C${YELLOW}]opy git-diffi to /usr/local/bin "
    printf "or [${RESET}S${YELLOW}]kip this step ${RESET} "
    read opt
    case $opt in
        l*|L*|"") ln -s "$PWD/git-diffi" "/usr/local/bin/git-diffi"
    echo "symlinked ${GREEN}$PWD/git-diffi${RESET} -> ${GREEN}/usr/local/bin/${RESET}" ;;
        c*|C*) cp "$PWD/git-diffi" "/usr/local/bin/git-diffi"
    echo "copied ${GREEN}$PWD/git-diffi${RESET} -> ${GREEN}/usr/local/bin/${RESET}" ;;
        s*|S*) echo "git-diffi install skipped."; return ;;
        *) echo "Invalid choice. Setup aborted"; exit 1 ;;
    esac
}

check_git
ln_or_cp
alias_diffi
cp_global
