install_golang() {
	# note: see variables defined in ./tools/config.bash
	local golang_sha256="adab2483f644e2f8a10ae93122f0018cef525ca48d0b8764dae87cb5f4fd4206"
	local golang_tarball=go${golang_version}.linux-amd64.tar.gz
	if [[ -d $golang_sdk ]]; then
		return
	fi
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

install_shfmt() {
	if [[ -x $HOME/go/bin/shfmt ]]; then
		return
	fi
	run go install mvdan.cc/sh/v3/cmd/shfmt@latest
}

check_whether_docker_is_working() {
	echo "monorepo: checking whether docker is working..."
	run docker run hello-world
}

check_whether_we_have_qemu_user_static() {
	echo "monorepo: checking whether we have qemu-user-static package..."
	require_commands qemu-aarch64-static
}

install_android_sdk() {
	# note: see variables defined in ./tools/config.bash
	if [[ -d $android_sdk ]]; then
		return
	fi
	local clitools_file="commandlinetools-linux-7583922_latest.zip"
	local clitools_url="https://dl.google.com/android/repository/$clitools_file"
	local clitools_sha256="124f2d5115eee365df6cf3228ffbca6fc3911d16f8025bebd5b1c6e2fcfa7faf"
	run curl -fsSLO $clitools_url
	echo "${clitools_sha256}  ${clitools_file}" >SHA256SUMS
	run sha256sum -c SHA256SUMS
	run mkdir -p $sdk_base_dir
	run rm -rf $android_sdk
	run unzip $clitools_file
	run mkdir -p $android_sdk/cmdline-tools
	run mv cmdline-tools $android_sdk/cmdline-tools/latest
}

installer_main() {
	require_path_entries
	require_commands curl docker gcc git java javac make sha256sum unzip
	install_golang
	require_commands go
	install_shfmt
	require_commands shfmt
	check_whether_docker_is_working
	check_whether_we_have_qemu_user_static
	install_android_sdk
}
