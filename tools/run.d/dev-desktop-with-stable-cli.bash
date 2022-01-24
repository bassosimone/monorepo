workflow_info() {
	echo "runs desktop in dev mode with the stable cli"
}

workflow_run() {
	(
		run cd repo/probe-desktop
		run yarn install
		run yarn download:probe-cli
		run yarn dev
	)
}
