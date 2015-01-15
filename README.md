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

## Getting Started

Once you've installed the gem, you will be able to run the `codeunion` command:

```shell-session
$ codeunion
```

To run a particular subcommand, add it to the `codeunion` base command. For example, to use the search command you would run:

```shell-session
$ codeunion search [your search query]
```

You can see a help window for any subcommand by appending a `-h` or `--help` flag:

```shell-session
$ codeunion search -h
Usage: codeunion search [options] <terms>

Options:
-c, --category   CATEGORY        Display config variable NAME
-h, --help                       Print this help message
```

## Development

The CodeUnion client targets Ruby 1.9.3, 2.0, and 2.1. Assuming you have
[homebrew](http://brew.sh) installed already:

```
make install      # Installs npm, wach, rbenv, ruby-build and ruby 1.9.3, 2.0
                  # and 2.1
make unit-test    # Runs the unit tests against all ruby versions. Thread-safe.
make feature-test # Runs the feature tests against all ruby versions. Not-thread-safe.
make test         # Runs unit and feature tests against all ruby versions
```

### How Subcommands Work

The command-line tool is organized into subcommands, a la git.  If we were to
run this command, for example

```shell-session
$ codeunion waffles
```

the CodeUnion tool would look for an executable named `codeunion-waffles`.  If
the executable exists, the tool will run it.  If it doesn't exist, we would see
a `CommandNotFound` error.
