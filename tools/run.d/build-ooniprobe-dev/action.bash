action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cd repo/probe-cli
	# TODO(bassosimone): this rule should probably use the psiphon config
	run $golang_go build -o $destdir/ooniprobe-dev ./cmd/ooniprobe
}
