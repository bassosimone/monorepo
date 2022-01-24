workflow_info() {
	echo "builds a new oonimkall.aar release"
}

# TODO: instead of this workflow we should probably have a larger
# one that builds all the releases and runs tests?

workflow_run() {
	run_action build_oonimkall_android
}
