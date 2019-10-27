# diffi

diffi is an attempt to provide glob pattern matching using a `.diffignore` file in an attempt
to reduce the amount of 'noisy' commited files one sees during a git diff.

## USAGE:

* `./setup.sh` configures diffi installation and aliasing.

* `git diffi` can be used in any situation a `git diff` can be used.

* You can create a .diffignore.base in any git project by calling:

    `$ git diffi --init`

    This will create a `.diffignore.base` in the root git directory using the 
    file set by the `$DIFFIGNORE_GLOBAL` variable (`~/.diffignore.global` by default)


* git-diffi can be configured to use git diff autocompletion with this command:
    `$ git config --global alias.diffi '!git diff'`


