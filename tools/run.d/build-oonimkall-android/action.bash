action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	local gomobile=$($golang_go env GOPATH)/bin/gomobile
	run cd repo/probe-cli
	# TODO(bassosimone): figure out why using `go install` as
	# recommended by the warning that appears when running the
	# following command causes `$gomobile init` to fail.
	run $golang_go get -u golang.org/x/mobile/cmd/gomobile
	run $gomobile init
	run export ANDROID_HOME=$android_sdk
	run export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/$android_ndk_version
	run export PATH=$oonigo_path:$($golang_go env GOPATH)/bin:$PATH
	run which gobind
	run which gomobile
	run which go
	run $gomobile bind -x -target android -o oonimkall.aar \
		-tags ooni_psiphon_config -ldflags "-s -w" ./pkg/oonimkall
	run mv oonimkall.aar $destdir
	run mv oonimkall-sources.jar $destdir
}
