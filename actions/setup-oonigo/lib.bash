setup_oonigo_depends() {
	echo "setup_go"
}

setup_oonigo_main() {
	[[ -n ${sdk_base_dir+x} ]] || variable_not_set sdk_base_dir
	[[ -n ${oonigo_sdk+x} ]] || variable_not_set oonigo_sdk
	[[ -n ${oonigo_version+x} ]] || variable_not_set oonigo_version
	[[ -n ${oonigo_go+x} ]] || variable_not_set oonigo_go
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
