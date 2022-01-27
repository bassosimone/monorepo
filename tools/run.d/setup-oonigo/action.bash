action_main() {
	run mkdir -p $sdk_base_dir
	if ! [[ -d $oonigo_sdk ]]; then
		(
			run cd $sdk_base_dir
			run git clone -b $oonigo_version git@github.com:ooni/go $oonigo_version
		)
	fi
	info "oonigo SDK at $oonigo_sdk"
	if ! [[ -x $oonigo_go ]]; then
		(
			run cd $oonigo_sdk/src
			run ./make.bash
		)
	fi
	info "oonigo binary at $oonigo_go"
	local real_version=$($oonigo_go version | awk '{print $3}')
	if [[ "go${golang_version}" != "${real_version}" ]]; then
		fatal "wrong golang version ${real_version} (expected ${golang_version})"
	fi
	success "oonigo version is ${golang_version}"
}
