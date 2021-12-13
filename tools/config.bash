# List of repositories to sync
repositories=(
	git@github.com:ooni/api
	git@github.com:ooni/asn-db-generator
	git@github.com:ooni/backend
	git@github.com:ooni/pipeline
	git@github.com:ooni/probe-android
	git@github.com:ooni/probe-assets
	git@github.com:ooni/probe-cli
	git@github.com:ooni/probe-desktop
	git@github.com:ooni/probe-ios
	git@github.com:ooni/probe-private
	git@github.com:ooni/translations
)

sdk_base_dir=$HOME/sdk

# The version of golang to use
golang_version="1.17.4"
golang_sdk=$sdk_base_dir/go$golang_version
golang_path=$golang_sdk/bin
golang_go=$golang_path/go

# The Android SDK to use
android_cmdline_tools_version=latest
android_build_tools_version=32.0.0
android_ndk_version=23.1.7779620
android_platform_version=android-31

# The ooni/go SDK to use
oonigo_version=oonigo$golang_version
oonigo_sdk=$sdk_base_dir/$oonigo_version
oonigo_path=$oonigo_sdk/bin
oonigo_go=$oonigo_path/go

# The keystore to use for signing experimental-full-release builds
android_efr_keystore=ooniprobe-efr.jks
android_efr_keystore_password=ooniprobe
android_efr_keystore_keyalias=key0
android_efr_keystore_validity=7
