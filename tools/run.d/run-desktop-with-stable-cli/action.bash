action_main() {
	run cd repo/probe-desktop
	run yarn install
	run yarn download:probe-cli
	run yarn dev
}
