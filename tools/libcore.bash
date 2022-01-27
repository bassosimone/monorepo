source ./config/lib.bash

fatal() {
	echo "🚨 $@" 1>&2
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
	echo "🐚 $@" 1>&2
	"$@"
}

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
