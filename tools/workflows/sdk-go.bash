workflow_info() {
	echo "verifies we're using the right version of go"
}

workflow_run() {
	if [[ -z "${golang_version+x}" ]]; then
		echo "fatal: golang_version is not set" 1>&2
		exit 1
	fi
	echo -n "monorepo: checking for go... "
	local golang=$(command -v go)
	if [[ -z "${golang}" ]]; then
		echo "not found"
		exit 1
	fi
	echo "${golang}"
	echo -n "monorepo: checking whether golang version is ${golang_version}... "
	local real_version=$(go version | awk '{print $3}')
	if [[ "go${golang_version}" != "${real_version}" ]]; then
		echo "no"
		exit 1
	fi
	echo "yes"
}
