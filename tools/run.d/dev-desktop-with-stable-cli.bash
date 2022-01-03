workflow_info() {
	echo "runs desktop in dev mode with the stable cli"
}

workflow_run() {
	local desktop=./repo/probe-desktop
	(
		run cd repo/probe-desktop
		run yarn install
		run yarn download:probe-cli
		run yarn dev
	)
}
