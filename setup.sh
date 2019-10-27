#!/bin/sh

set -e

DIFFIGNORE_GLOBAL=${DIFFIGNORE_GLOBAL:-~/.diffignore.global}
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

alias_diffi() {
    printf "${YELLOW}Do you want git-diffi to use git diff autocompletion? [Y/n]${RESET} "
    read opt
    case $opt in
        y*|Y*|"") echo "Adding autocompletion to git-diffi" ;;
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

You can create a .diffignore.base in any git project by calling:
    $ git diffi --init
This will create a .diffignore.base in the root git directory using the 
file provided by the ${YELLOW}\$DIFFIGNORE_GLOBAL${RESET} path (~/.diffignore.global by default)

EOF
}


cp_global_diffi() {
    printf "${YELLOW}Do you want to create a $DIFFIGNORE_GLOBAL?[Y/n]${RESET} "
    read opt
    case $opt in
        y*|Y*|"") echo "Creating global diffignore"; global_diffi_doc ;;
        n*|N*) echo "Global diffignore skipped.";  global_diffi_doc; return ;;
        *) echo "Invalid choice. Aliasing aborted."; return ;;
    esac
    cp "$PWD/.diffignore.global" "$DIFFIGNORE_GLOBAL"
    echo "${GREEN}$DIFFIGNORE_GLOBAL:${RESET}"
    cat "$DIFFIGNORE_GLOBAL"
}


ln_or_cp() {
    printf "${YELLOW}Do you want to Sym[L]ink or [c]opy git-diffi to /usr/local/bin "
    printf "or [S]kip this step [L/c/S]${RESET} "
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
cp_global_diffi
