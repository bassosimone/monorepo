action_main() {
	[[ -d ${golang_sdk} ]] || {
		run curl -fsSLO https://go.dev/dl/${golang_tarball}
		echo "${golang_sha256}  ${golang_tarball}" >SHA256SUMS
		run sha256sum -c SHA256SUMS
		run mkdir -p $sdk_base_dir
		run rm -rf $golang_sdk
		run tar -C $sdk_base_dir -xf ${golang_tarball}
		run mv $sdk_base_dir/go $golang_sdk
	}
	require_commands $golang_go
	local real_version=$($golang_go version | awk '{print $3}')
	if [[ "go${golang_version}" != "${real_version}" ]]; then
		fatal "unexpected golang version ${real_version} (expected ${golang_version})"
	fi
	success "golang version is ${golang_version}"
}
