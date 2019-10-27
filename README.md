# git-diffi

## USAGE:

* You can create a .diffignore.base in any git project by calling:

    `$ git diffi --init`

    This will create a `.diffignore.base` in the root git directory using the 
    file set by the `$DIFFIGNORE_GLOBAL` variable (`~/.diffignore.global` by default)


* git-diffi can be configured to use git diff autocompletion with this command:
    `$ git config --global alias.diffi '!git diff'`


