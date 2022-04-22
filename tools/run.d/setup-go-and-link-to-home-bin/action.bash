action_main() {
	require_commands $golang_go
	run rm -f $HOME/bin/go
	run ln -s $golang_go $HOME/bin/go
}
