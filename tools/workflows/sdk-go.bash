workflow_info() {
	echo "downloads the required Go SDK"
}

workflow_run() {
	if [[ -z "${golang_version+x}" ]]; then
		echo "fatal: golang_version is not set" 1>&2
		exit 1
	fi
	if ! [[ -d $golang_sdk ]]; then
		run go install golang.org/dl/go${golang_version}@latest
		run $HOME/go/bin/go${golang_version} download
	fi
}
