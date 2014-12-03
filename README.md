# The CodeUnion Command-Line Tool

The CodeUnion command-line tool is meant to be used in conjunction with
CodeUnion's curriculum.  Think of it as your "learning sherpa."

## Installing

To install the CodeUnion command-line tool, run

```shell-session
$ gem install codeunion
```

If you're using [rbenv](http://rbenv.org/) to manage your Ruby environment,
make sure to run

```shell-session
$ rbenv rehash
```

after you install the gem.  This is required for rbenv to pick up any new
executables installed by a gem, including ours.

## Subcommands

The command-line tool is organized into subcommands, a la git.  If we were to
run this command, for example

```shell-session
$ codeunion waffles
```

the CodeUnion tool would look for an executable named `codeunion-waffles`.  If
the executable exists, the tool will run it.  If it doesn't exist, we would see
a `CommandNotFound` error.
