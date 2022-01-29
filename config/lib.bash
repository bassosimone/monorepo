#doc: # config/lib.bash
#doc:
#doc: This file sets configuration variables.
#doc:
#doc: ## repositories (array)
#doc:
#doc: Contains the list of repositories to sync.
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

#doc:
#doc: ## sdk_base_dir (string)
#doc:
#doc: This is the base directory where we install the SDK for
#doc: developing ooniprobe. Defaults to `$HOME/sdk`.
sdk_base_dir=$HOME/sdk

#doc:
#doc: ## platform (function)
#doc:
#doc: The platform function echoes the system name followed by
#doc: a dash followed by the machine name.
platform() {
	echo "$(uname -s)-$(uname -m)"
}

#doc:
#doc: ## group: golang
#doc:
#doc: This group contains Go language SDK variables.

#doc:
#doc: ### golang_version (string)
#doc:
#doc: This is the version of Go to install.
golang_version="1.17.6"

#doc:
#doc: ### golang_sdk (string)
#doc:
#doc: This is the directory in which we download the Go SDK,
#doc: which defaults to $sdk_base_dir/go$golang_version.
golang_sdk=$sdk_base_dir/go$golang_version

#doc:
#doc: ### golang_path (string)
#doc:
#doc: This is the directory to add to the PATH to execute
#doc: the specific Go version we downloaded.
golang_path=$golang_sdk/bin

#doc:
#doc: ### golang_go (string)
#doc:
#doc: Path of the go executable withing $golang_sdk.
golang_go=$golang_path/go

#doc:
#doc: ## group: android
#doc:
#doc: Android SDK variables.

#doc:
#doc: ### android_sdk (string)
#doc:
#doc: Location where to download the Android SDK.
android_sdk=$HOME/sdk/ooni-android

#doc:
#doc: ### android_cmdline_tools_version (string)
#doc:
#doc: Version of the Android command line tools to download.
android_cmdline_tools_version=latest

#doc:
#doc: ### android_build_tools_version (string)
#doc:
#doc: Version of the Android build tools to download.
android_build_tools_version=32.0.0

#doc:
#doc: ### android_ndk_version (string)
#doc:
#doc: Version of the Android NDK to download.
android_ndk_version=23.1.7779620

#doc:
#doc: ### android_platform_version (string)
#doc:
#doc: Version of the Android platform tools to use.
android_platform_version=android-31

#doc:
#doc: ## group: oonigo
#doc:
#doc: Variables related to the github.com/ooni/go fork.

#doc:
#doc: ### oonigo_version (string)
#doc:
#doc: Version of ooni/go to use.
oonigo_version=oonigo$golang_version

#doc:
#doc: ### oonigo_sdk (string)
#doc:
#doc: Directory where we download the ooni/go SDK.
oonigo_sdk=$sdk_base_dir/$oonigo_version

#doc:
#doc: ### oonigo_path (string)
#doc:
#doc: Directory of the ooni/go SDK to add to the PATH.
oonigo_path=$oonigo_sdk/bin

#doc:
#doc: ### oonigo_go (string)
#doc:
#doc: Path to the go binary within the ooni/go SDK.
oonigo_go=$oonigo_path/go

#doc:
#doc: ## group: android_efr
#doc:
#doc: This group contains Android EFR (= Experimental Full
#doc: Release) configuration variables.

#doc:
#doc: ### android_efr_keystore_password (string)
#doc:
#doc: This is the password of the ephemeral keystore for signing EFR builds.
android_efr_keystore_password=ooniprobe

#doc:
#doc: ### android_efr_keystore_keyalias (string)
#doc:
#doc: This is the keyalias we'll use.
android_efr_keystore_keyalias=key0

#doc:
#doc: ### android_efr_keystore_validity (string)
#doc:
#doc: This is the generated key validity expressed in days.
android_efr_keystore_validity=7

#doc:
#doc: ## group: platform-specific config
#doc:
#doc: For any supported platform name, there should be a
#doc: file named `./config/<system>-<marchine>.bash` that
#doc: will contain platform specific settings.

source ./config/$(platform).bash

#doc:
#doc: ## group: local configuration
#doc:
#doc: If the `./config/local.bash` file exists, we'll read it.

if [[ -f ./config/local.bash ]]; then
	source ./config/local.bash
fi
