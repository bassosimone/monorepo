action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cd repo/probe-cli
	# TODO(bassosimone): this rule should probably use the psiphon config
	run go build -o $destdir/ooniprobe-dev ./cmd/ooniprobe
}
