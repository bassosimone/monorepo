# Monorepo-like setup for OONI development

This repository contains the set of scripts I use for developing OONI in a
monorepo like fashion. We obviously do not have a single repository and there
are some advantages in this setup, including easier to grok history.

At the same time, it's quite advantageous to perform one-command operations
such as testing the current ooni/probe-cli tree with the current ooni/probe-android
or ooni/probe-desktop tree. Being able to do that allows us to co-develop for
these products without passing through trial-and-error commit, push, pull request,
publish artifacts, download and integrate processes.

## Local setup

The `./tools/run` script will automatically download the expected version of `go`
under `$HOME/sdk/go${version}` and will transparently use it.

Also, if you're not a OONI developer, you need to do just once:

```bash
cp config/local.bash.example config/local.bash
```

to apply local configuration that disables private repositories.

## Design

The `tools` directory contains the top-level tools that one should be running. I
don't expect most of the scripts to change significantly over time. Most of them deal
with performing parallel `git` operations across all repos, which is something that
is already workking reasonably well for me. These are the git-related scripts:

* `checkout <branch>`: checks out a branch in all repositories;
* `clean`: runs `git clean -dffx` in all repositories;
* `commit <file>`: commits with the commit message in file in all changed repos;
* `diff [--cached]`: diffs all the repos with respect to the base branch;
* `info`: emits workflow programming documentation on the stdout;
* `push`: pushes the current branch to all repos;
* `reset`: runs `git reset --hard HEAD` and checkouts the default branch in all repos;
* `status`: shows the status of rach repo;
* `sync`: must be run from the base branch and pulls from upstream;
* `vscode`: convenience script to open a directory using vscode.

The base branch is forced to be `main` in each repository. The development workflow is roughly the following:

1. you start from a clean tree;
2. you `sync`;
3. you `checkout issue/xxx` to work on an issue;
4. you `diff` to see the changes;
5. you use `run` (more on this below) to test the changes;
6. you `commit` across all the repos;
7. you `push` across all repos and (manually for now) open pull requests;
8. you eventually merge all pull requests;
9. you `reset` back to a clean tree.

To run a development or release workflow, you use the `./tools/run` command. Invoked
without arguments, it prints its usage plus the names of the available workflows.

If you pass `./tools/run` the name of a workflow, it will run it.

A workflow is a `workflow.yml` file in a subdirectory of `tools/run.d`. The name
of the subdirectory is the name of the workflow. So, for example, the `hello-world`
workflow is the `./tools/run.d/hello-world/workflow.yml` file.

To read more about developing workflows, you should consult the
documentation emitted by the `./tools/info` command.

## Experimental code

Code inside the [x](x) directory is experimental.
