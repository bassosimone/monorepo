action_main() {
	if [[ ! -x $HOME/go/bin/shfmt ]]; then
		run go install mvdan.cc/sh/v3/cmd/shfmt@latest
	fi
	require_commands shfmt
}
