workflow_info() {
	echo "installs the ooni/go SDK in $HOME/sdk"
}

workflow_run() {
	run ./tools/run sdk-go
	run mkdir -p $sdk_base_dir
	if ! [[ -d $oonigo_sdk ]]; then
		(
			run cd $sdk_base_dir
			run git clone -b $oonigo_version git@github.com:ooni/go $oonigo_version
		)
	fi
	if ! [[ -x $oonigo_go ]]; then
		(
            run cd $oonigo_sdk/src
			run export PATH=$golang_path:$PATH
            run ./make.bash
		)
	fi
}
