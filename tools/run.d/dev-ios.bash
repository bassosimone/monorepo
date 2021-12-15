workflow_info() {
	echo "runs pod install and then opens the iOS workspace"
}

workflow_run() {
	cd ./repo/probe-ios
	pod install
	open ooniprobe.xcworkspace
}
