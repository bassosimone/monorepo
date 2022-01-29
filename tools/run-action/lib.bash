setup_defaults_main() {
	require_commands curl gcc git java javac make sha256sum unzip
	source ./tools/run-action/$(platform).bash
	setup_defaults_platform_main
}
