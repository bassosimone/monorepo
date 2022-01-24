setup_defaults_depends() {
	echo ""
}

require_path_entries() {
	local found_home_bin=0
	local found_home_go_bin=0
	for entry in $(echo $PATH | sed 's/:/ /g'); do
		if [[ $entry == "$HOME/bin" ]]; then
			found_home_bin=1
		elif [[ $entry == "$HOME/go/bin" ]]; then
			found_home_go_bin=1
		fi
	done
	if [[ $found_home_bin == 0 ]]; then
		fatal "$HOME/bin is not in PATH... please, add it!"
	fi
	success "$HOME/bin is in PATH... yay!"
	if [[ $found_home_go_bin == 0 ]]; then
		fatal "$HOME/go/bin is not in PATH... please, add it!"
	fi
	success "$HOME/go/bin is in PATH... yay!"
}

setup_defaults_main() {
	require_path_entries
	require_commands curl gcc git java javac make sha256sum unzip
}
