# Actions

This directory contains actions. Each action is a bash script that
performs a well defined operations and produces an output.

You generally use an action as follows:

```bash
source ./actions/lib.bash
run_action $action_name
```

The `$action_destdir` environment variable could be used to choose the
directory in which an action could write its outputs. If such a variable
is not specified, the default directory is the `./output` one.

Likewise, the `$action_srcdir` variable controls the directory from
which an action should read its input. The default is `./output`.
