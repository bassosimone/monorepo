action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cd repo/probe-cli
	run go build -o $destdir/ooniprobe-dev ./cmd/ooniprobe
}
