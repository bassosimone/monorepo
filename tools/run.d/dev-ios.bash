workflow_info() {
	echo "runs pod install and then opens the iOS workspace"
}

workflow_run() {
	(
		run cd ./repo/probe-ios
		run pod install
		run open ooniprobe.xcworkspace
	)
}
