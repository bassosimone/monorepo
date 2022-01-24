setup_go_depends() {
	echo "setup_defaults"
}

setup_go_main() {
	[[ ! -z ${golang_sdk+x} ]] || variable_not_set golang_sdk
	[[ ! -z ${golang_tarball+x} ]] || variable_not_set golang_tarball
	[[ ! -z ${golang_sha256+x} ]] || variable_not_set golang_sha256
	[[ ! -z ${sdk_base_dir+x} ]] || variable_not_set sdk_base_dir
	[[ -d ${golang_sdk} ]] || {
		run curl -fsSLO https://go.dev/dl/${golang_tarball}
		echo "${golang_sha256}  ${golang_tarball}" >SHA256SUMS
		run sha256sum -c SHA256SUMS
		run mkdir -p $sdk_base_dir
		run rm -rf $golang_sdk
		run tar -C $sdk_base_dir -xf ${golang_tarball}
		run mv $sdk_base_dir/go $golang_sdk
		run mkdir -p $HOME/bin
		run ln -fs $golang_sdk/bin/go $HOME/bin/go
	}
	require_commands go
	local real_version=$(go version | awk '{print $3}')
	if [[ "go${golang_version}" != "${real_version}" ]]; then
		fatal "wrong golang version ${real_version} (expected ${golang_version})"
	fi
	success "golang version is ${golang_version}"
}
