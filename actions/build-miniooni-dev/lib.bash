build_miniooni_dev_depends() {
	echo "setup_go setup_psiphon"
}

build_miniooni_dev_main() {
	local destdir="$(realpath ${action_destdir:-./output})"
	(
		run cd repo/probe-cli
		run go build -o $destdir/miniooni-dev ./internal/cmd/miniooni
	)
}
