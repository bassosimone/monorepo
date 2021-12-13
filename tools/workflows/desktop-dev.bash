workflow_info() {
    echo "runs desktop in dev mode with a cli build in dev mode"
}

workflow_run() {
    if [[ "$(uname -s)" != "Linux" ]]; then
        echo "fatal: this command only works on Linux" 1>&2
        exit 1
    fi
    if [[ "$(uname -m)" != "x86_64" ]]; then
        echo "fatal: this command only works on amd64" 1>&2
        exit 1
    fi
    run ./tools/run sdk-go
    local cli="./repo/probe-cli"
    local desktop="./repo/probe-desktop"
    local target="linux_amd64"
	run mkdir -p $desktop/build/probe-cli/$target
	(
        run cd $cli
        run $golang_go build -ldflags "-s -w" ./cmd/ooniprobe
    )
	run cp -p $cli/ooniprobe $desktop/build/probe-cli/$target
	(
        run cd repo/probe-desktop
        run yarn install
        run yarn dev
    )
}
