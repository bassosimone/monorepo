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

# The version of golang to use
golang_version="1.17.4"
golang_sdk=$HOME/sdk/go${golang_version}
golang_path=${golang_sdk}/bin
golang_go=${golang_path}/go
