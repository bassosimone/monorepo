workflow_info() {
	echo "downloads the required Android SDK"
}

workflow_run() {
	local cmdline_tools=$android_sdk/cmdline-tools/$android_cmdline_tools_version
	if ! [[ -d $cmdline_tools ]]; then
		echo "fatal: you must install the latest cmdline-tools version" 1>&2
		exit 1
	fi
	run export ANDROID_HOME=$android_sdk
	local sdkmanager=$cmdline_tools/bin/sdkmanager
	echo "Yes" | run $sdkmanager --install "ndk;$android_ndk_version"
	echo "Yes" | run $sdkmanager --install "build-tools;$android_build_tools_version"
	echo "Yes" | run $sdkmanager --install "platforms;$android_platform_version"
}
