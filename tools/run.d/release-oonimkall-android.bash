workflow_info() {
	echo "builds a new oonimkall.aar release"
}

workflow_run() {
	run_action build_oonimkall_android
}
