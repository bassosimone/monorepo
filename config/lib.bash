platform() {
	echo "$(uname -s)-$(uname -m)"
}

fatal() {
	echo "🚨 $@" 1>&2
	exit 1
}

info() {
	echo "🗒️ $@" 1>&2
}

success() {
	echo "✔️ $@" 1>&2
}

variable_not_set() {
	fatal "variable not set: $1"
}

run() {
	echo "🐚 $@" 1>&2
	"$@"
}

require_commands() {
	while [[ $# > 0 ]]; do
		local name=$1
		shift
		local cmd=$(command -v $name)
		if [[ -z $cmd ]]; then
			fatal "command $name not found"
		fi
		success "command $name is $cmd"
	done
}

# List of repositories to sync
repositories=(
	git@github.com:ooni/api
	git@github.com:ooni/backend
	git@github.com:ooni/pipeline
	git@github.com:ooni/probe-android
	git@github.com:ooni/probe-assets
	git@github.com:ooni/probe-cli
	git@github.com:ooni/probe-desktop
	git@github.com:ooni/probe-ios
	git@github.com:ooni/probe-private
	git@github.com:ooni/run
	git@github.com:ooni/translations
)

# Base dir where we install the SDK
sdk_base_dir=$HOME/sdk

# Go
golang_version="1.17.6"
golang_sdk=$sdk_base_dir/go$golang_version
golang_path=$golang_sdk/bin
golang_go=$golang_path/go

# Android
android_sdk=$HOME/sdk/android
android_cmdline_tools_version=latest
android_build_tools_version=32.0.0
android_ndk_version=23.1.7779620
android_platform_version=android-31

# github.com/ooni/go
oonigo_version=oonigo$golang_version
oonigo_sdk=$sdk_base_dir/$oonigo_version
oonigo_path=$oonigo_sdk/bin
oonigo_go=$oonigo_path/go

# Android EFR (= ExperimentalFullRelease) keystore
android_efr_keystore=ooniprobe-efr.jks
android_efr_keystore_password=ooniprobe
android_efr_keystore_keyalias=key0
android_efr_keystore_validity=7

# Platform specific config
source ./config/$(platform).bash
