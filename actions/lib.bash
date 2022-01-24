source ./config/lib.bash

run_action() {
	for action in $($1_depends); do
		run_action $action
	done
	info "running action: $1"
	"$1_main"
}

actions=()
for dir in $(ls ./actions); do
	if [[ -d ./actions/$dir ]]; then
		source ./actions/$dir/lib.bash
		name=$(echo $dir | sed 's/-/_/g')
		actions+=($name)
	fi
done
