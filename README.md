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
8. you `reset` back to a clean tree.

Speaking of running development workflows, I originally used to have scripts in
`tools/run.d` that one could invoke with the `./tools/run` command to run specific
development workflows. For example, one could get an APK to test on device using
the `./tools/run dev-android` command.

While the `./tools/run dev-android` command is _still_ WAI in the moment in which
I am writing these notes, the under-the-hood design has been changing a little since
what I have described above. I am currently (slowly, because this is only done on a
I-need-this-now basis) refactoring the code to have independent `actions` that
could run in sequence as part of `pipelines`. This design seems one with which a
bunch of people is familiar with and, also, crucially, is quite nice in separating
more cleanly the actions. Otherwise, the set of scripts quickly become a maze.

However, that is still up in the air and, in any case, I would like to avoid breaking
too much the `./tools/run <name>` semantics for running a "pipeline". What shouldn't
change, I think, is that `./tools/run` without arguments will list all the available
"pipelines" that you could run. But maybe pipeline names will change.

