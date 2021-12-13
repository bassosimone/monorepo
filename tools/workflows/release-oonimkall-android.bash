workflow_info() {
	echo "builds a new oonimkall.aar release"
}

workflow_run() {
	if [[ -z "$ANDROID_HOME" ]]; then
		echo "fatal: ANDROID_HOME is not set" 1>&2
		exit 1
	fi
	run ./tools/run sdk-go
	run ./tools/run sdk-android
	run ./tools/run sdk-oonigo
	local cli="./repo/probe-cli"
	local android="./repo/probe-android"
	local gomobile=$($golang_go env GOPATH)/bin/gomobile
	(
		local tempdir=$(mktemp -d)
		run cd $tempdir
		run $golang_go mod init example.org/gomobile
		run $golang_go get -d golang.org/x/mobile/...
		run $golang_go install golang.org/x/mobile/cmd/gomobile@latest
		run $golang_go install golang.org/x/mobile/cmd/gobind@latest
		run $gomobile init
		run rm -rf $tempdir
	)
	(
		run cd $cli
		run export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/$android_ndk_version
		run export PATH=$oonigo_path:$($golang_go env GOPATH)/bin:$PATH
		run which gobind
		run which gomobile
		run which go
		# TODO(bassosimone): add support for psiphon
		run $gomobile bind -target android -o oonimkall.aar \
			-ldflags "-s -w" ./pkg/oonimkall
	)
	run mv $cli/oonimkall.aar ./release
	run mv $cli/oonimkall-sources.jar ./release
}
