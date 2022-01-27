# Monorepo-like setup for OONI development

This repository contains the set of scripts I use for developing OONI in a
monorepo like fashion. We obviously do not have a single repository and there
are some advantages in this setup, including easier to grok history.

At the same time, it's quite advantageous to perform one-command operations
such as testing the current ooni/probe-cli tree with the current ooni/probe-android
or ooni/probe-desktop tree. Being able to do that allows us to co-develop for
these products without passing through trial-and-error commit, push, pull request,
publish artifacts, download and integrate processes.

## Design

The `tools` directory contains the top-level tools that one should be running. I
don't expect most of the scripts to change significantly over time. Most of them deal
with performing parallel `git` operations across all repos, which is something that
is already workking reasonably well for me. These are the git-related scripts:

* `checkout <branch>`: checks out a branch in all repositories;
* `clean`: runs `git clean -dffx` in all repositories;
* `commit <file>`: commits with the commit message in file in all changed repos;
* `diff [--cached]`: diffs all the repos with respect to the base branch;
* `push`: pushes the current branch to all repos;
* `reset`: runs `git reset --hard HEAD` and checkouts the default branch in all repos;
* `status`: shows the status of rach repo;
* `sync`: must be run from the base branch and pulls from upstream.

The base branch is forced to be `main` in each repository. The development workflow is:

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
of the subdirectory is the name of the workflow.

Each workflow step calls an action. An action is an (hopefully) reusable bash
script named `action.bash` to also lives in subdirectories of `tools/run.d`.

The same subdirectory could contain both a workflow and an action. This happens
when the workflow invokes a namesake action.

A directory without actions is a workflow that refers to differently named
actions. A directory without a workflow only contains actions and cannot be
called directly from `./tools/run`.

See the `./tools/run.d/hello-world` directory for a very simple example
of how to write a worklow and an action.