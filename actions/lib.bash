fatal() {
	echo "🚨$@" 1>&2
	exit 1
}

info() {
	echo "🗒️ $@" 1>&2
}

success() {
	echo "✔️ $@" 1>&2
}

variable_not_set() {
	fatal "variable not set: $1"
}

run() {
	echo "🐚[$(pwd)] $@" 1>&2
	"$@"
}

require_commands() {
	while [[ $# > 0 ]]; do
		local name=$1
		shift
		local cmd=$(command -v $name)
		if [[ -z "$cmd" ]]; then
			fatal "command $name not found"
		fi
		success "command $name is $cmd"
	done
}

run_action() {
	for action in $($1_depends); do
		run_action $action
	done
	info "running action: $1"
	"$1_main"
}

source ./actions/setup-defaults/lib.bash
source ./actions/setup-go/lib.bash
source ./actions/setup-oonigo/lib.bash
source ./actions/setup-shfmt/lib.bash
