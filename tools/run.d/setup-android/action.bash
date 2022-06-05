action_main() {
	local cmdline_tools=$android_sdk/cmdline-tools/latest
	if [[ ! -d $cmdline_tools ]]; then
		# Apparently, the same version works everywhere because Java is portable \m/
		local clitools_file="commandlinetools-linux-7583922_latest.zip"
		local clitools_url="https://dl.google.com/android/repository/$clitools_file"
		local clitools_sha256="124f2d5115eee365df6cf3228ffbca6fc3911d16f8025bebd5b1c6e2fcfa7faf"
		run curl -fsSLO $clitools_url
		echo "$clitools_sha256  $clitools_file" >SHA256SUMS
		run sha256sum -c SHA256SUMS
		run rm -rf $android_sdk
		run unzip $clitools_file
		run mkdir -p $android_sdk/cmdline-tools
		run mv cmdline-tools $cmdline_tools
	fi
	run export ANDROID_HOME=$android_sdk
	local sdkmanager=$cmdline_tools/bin/sdkmanager
	echo "Yes" | run $sdkmanager --install "ndk;$android_ndk_version"
	echo "Yes" | run $sdkmanager --install "build-tools;$android_build_tools_version"
	echo "Yes" | run $sdkmanager --install "platforms;$android_platform_version"
	run $sdkmanager --update
}
