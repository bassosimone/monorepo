workflow_info() {
	echo "builds a new oonimkall.aar release"
}

workflow_run() {
	run ./tools/run sdk-go
	run ./tools/run sdk-android
	run ./tools/run sdk-oonigo
	local cli="./repo/probe-cli"
	local gomobile=$($golang_go env GOPATH)/bin/gomobile
	(
		run cd $cli
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
		# TODO(bassosimone): add support for psiphon
		run $gomobile bind -target android -o oonimkall.aar \
			-ldflags "-s -w" ./pkg/oonimkall
	)
	run mv $cli/oonimkall.aar ./output
	run mv $cli/oonimkall-sources.jar ./output
}
