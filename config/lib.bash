#doc: # config/lib.bash
#doc:
#doc: This file sets configuration variables.
#doc:
#doc: ## repositories (array)
#doc:
#doc: Contains the list of repositories to sync.
repositories=(
	git@github.com:citizenlab/test-lists
	git@github.com:neubot/dash
	git@github.com:ooni/api
	git@github.com:ooni/backend
	git@github.com:ooni/data
	git@github.com:ooni/minivpn
	git@github.com:ooni/oocrypto
	git@github.com:ooni/oohttp
	git@github.com:ooni/ooni.org
	git@github.com:ooni/pipeline
	git@github.com:ooni/probe-android
	git@github.com:ooni/probe-assets
	git@github.com:ooni/probe-cli
	git@github.com:ooni/probe-desktop
	git@github.com:ooni/probe-ios
	git@github.com:ooni/probe-private
	git@github.com:ooni/probe-releases
	git@github.com:ooni/psiphon
	git@github.com:ooni/run
	git@github.com:ooni/spec
	git@github.com:ooni/translations
)

#doc:
#doc: ## goos (function)
#doc:
#doc: Echoes the operating system name using Go conventions.
goos() {
	case $(uname -s) in
	Linux)
		echo "linux"
		;;
	Darwin)
		echo "darwin"
		;;
	*)
		echo "FATAL: unsupported system" 1>&2
		exit 1
		;;
	esac
}

#doc:
#doc: ## goarch (function)
#doc:
#doc: Echoes the processor architecture using Go conventions.
goarch() {
	case $(uname -m) in
	amd64 | x86_64)
		echo "amd64"
		;;
	arm64)
		echo "arm64"
		;;
	*)
		echo "FATAL: unsupported arch" 1>&2
		exit 1
		;;
	esac
}

#doc:
#doc: ## group: ooni_psiphon
#doc:
#doc: This group contains settings related to OONI's
#doc: integration with the Psiphon tool.

#doc:
#doc: ### ooni_psiphon_config (string)
#doc:
#doc: This variable contains the string we should pass to
#doc: go -tags to enable tight Psiphon integration.
ooni_psiphon_config=ooni_psiphon_config

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
#doc: ## group: local configuration
#doc:
#doc: If the `./config/local.bash` file exists, we'll read it.

if [[ -f ./config/local.bash ]]; then
	source ./config/local.bash
fi
