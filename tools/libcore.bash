#doc: # ./tools/libcore.bash
#doc:
#doc: Bash functions used by all tools.

#doc:
#doc: This file sources ./config/lib.bash, so you don't need
#doc: to source ./config/lib.bash if you source this file.
source ./config/lib.bash

#doc:
#doc: ## fatal (function)
#doc:
#doc: This function prints its arguments on the stderr
#doc: and then terminates the execution.
fatal() {
	echo "🚨 $@" 1>&2
	exit 1
}

#doc:
#doc: ## info (function)
#doc:
#doc: This function prints an informational message
#doc: on the standard output.
info() {
	echo "🗒️ $@"
}

#doc:
#doc: ## success (function)
#doc:
#doc: This function prints a message on the standard
#doc: output indicating that some check succeded.
success() {
	echo "✔️ $@"
}

#doc:
#doc: ## run (function)
#doc:
#doc: This function emits a message on the standard
#doc: output indicating that it is about the execute
#doc: its arguments, then executes them.
run() {
	echo "🐚 $@"
	"$@"
}

#doc:
#doc: ## require_commands (function)
#doc:
#doc: This function fails if any of the commands it's
#doc: passed as argument does not exist in PATH.
require_commands() {
	while [[ $# > 0 ]]; do
		local name=$1
		shift
		local cmd=$(command -v $name)
		if [[ -z $cmd ]]; then
			fatal "command $name not found"
		fi
		success "command $name is $cmd"
	done
}
