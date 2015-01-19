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

## Subcommands

#### Config

Read and write configuration for the CodeUnion command-line tool.

Example usage:

```shell-session
# Set the feedback.repository value
$ codeunion config set feedback.repository codeunion/feedback-requests-web-fundamentals

# Get the feedback.repository value
$ codeunion config get feedback.repository
codeunion/feedback-requests-web-fundamentals
```

#### Feedback

Request feedback on your code.

Feedback requests require a URL for a _specific commit_ or a _pull request_.

Example usage:

```shell-session
$ codeunion feedback request https://github.com/codeunion/overheard-server/commit/0edb7866809620013d4a3c2d3b5bea57b12bf255
```

This will add an issue to the feedback repository specified in the config variable `feedback.repository`.

To use the feedback command, you will need to set the following configuration variables:

**`github.access_token`**<br>
Allows the tool to interact with GitHub as you. See [this article](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) for more information.

You can use the default OAuth scopes. As of this writing those are: `repo`, `public_repo`, `gist`, and `user`.

**`feedback.repository`**<br>
URL of the GitHub repository to submit feedback requests in. For example:  https://github.com/codeunion/feedback-requests-web-fundamentals

If you don't know which repository to use, see your workshop's base repository or ask your instructor.

#### Search

Search the repositories in the CodeUnion curriculum.

Example usage:

```shell-session
$ codeunion search html
  Project: social-wall
  Your First Web Application
  https://github.com/codeunion/social-wall
  tags:
  Excerpt: HTML templating and ERB - Deploying an application to Heroku
  The following video tutorials are all based...

  [...]
```

You can narrow your searches by category with the `--category` flag.


```shell-session
$ codeunion search html --category example
```

Or you can use the alias commands to narrow your search to either `projects` or `examples`.

```shell-session
$ codeunion examples html
```

...and...

```shell-session
$ codeunion projects html
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
