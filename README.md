# diffi

diffi is an attempt to provide glob pattern matching using a `.diffignore` file in order to
reduce the amount of 'noisy' commited files one views during a `git diff`.

`git diffi` can be used in any situation a `git diff` is used.

### Setup:

* `./setup.sh` configures diffi installation and aliasing.



### Initialising diffi:

* `$ git diffi --init` will create a `.diffignore` in the project root


    This will copy to the contents of the filepath set by the `DIFFI_GLOBAL` variable (`~/.diffignore.global` by default)

* `$ git diffi --init-base` will create a `.diffignore.base` in the project root using the same method

* diffi can be configured to use `git diff` autocompletion with this command:

    `$ git config --global alias.diffi '!git diff'`

### Patterns:

* `.diffignore.base` is intended to be committed to a project repo
* `.diffignore` is the file actually used by calling `git diffi` and should be added to the project `.gitignore`
* If a `.diffignore` is missing from the project root when calling `git diffi`, diffi will attempt to create one using the `.diffignore.base` present in the project root

