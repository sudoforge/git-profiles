# Directory-based profiles for Git

Add a fourth, workspace-level configuration file to your git profiles.
Manage your identity (and other settings) on a directory-based level!

## Overview

When you run a Git command, like `git commit`, Git looks in three different
configuration files for different settings, for things like the `user.name`
and `user.email` settings, in the following order:

- Your system-level configuration (`git config --system --edit`)
- Your global-level configuration (`git config --global --edit`)
- Your local-level configuration (`git config --local --edit`)

Each of the above configuration files overrides the other -- if your local
config has a `user.name` setting, then Git will use that value instead of
your global configuration's `user.name` setting. This enables you to control
your identity in different repositories.

The issue some people have, however, is that they do not want to have to set
their configuration settings for every repository they create. This project aims
to enable a fourth configuration file for easier identity management - the
_workspace_ level.

## How it works

This project provides a custom shell function named `git()`, which handles
temporarily injecting a workspace profile into your global configuration,
so that it overrides global settings, but is overridden by any local settings.
It accomplishes this by looking for a `.gitprofile` file inside any directories
defined in your global configuration's `profiles.location` keys.

## Installation

First, clone the repository to your local machine.

    git clone https://github.com/bddenhartog/git-profiles

Next, run the install command.

    make install

This adds a line to your existing runcom script(s) like `.bashrc` or `.zshrc`
that sources the wrapper function included in this repository.

## Usage

Let's take an example workspace structure from an imaginary programmer named Bob:

```text
/code
|
|- office/
|  |- some-work-repo/
|
|- personal/
|  |- bobs-repo/
|
|- client/
|  |- some-other-project/
```

Each of the tertiary child directories is a Git repository, and Bob manages
three different identities - `bob@office.xyz`, `bob@personal.xyz`, and
`bob@client.xyz`. In order to avoid having to manually add each identity to
every repository he ever creates in these directories, he can just use the
`git()` function wrapper provided by this project.

### First, create a profile

Bob will create a `.gitprofile` file in each of the parent directories:

```text
/code/office/.gitprofile
/code/personal/.gitprofile
/code/client/.gitprofile
```

These `.gitprofile` files work exactly like a `.gitconfig` file:

```ini
[user]
    name = Bob McBobberson
    email = bob@office.xyz
```

> Tip: Set keys and values using git by adding the `--file` option!
>
> `$ git config --file /code/office/.gitprofile user.name "Bob Mcbobberson"`

### Next, tell the global configuration about it

```shell
git config --global --add profile.path /code/office
git config --global --add profile.path /code/personal
git config --global --add profile.path /code/client
```

This adds a key/value pair in your global configuration.

### That's all, folks!

The next time you run a `git` command, your configured directory profiles
will be picked up.
