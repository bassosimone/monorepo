action_main() {
	run cd ./repo/probe-ios
	run pod install
	run open ooniprobe.xcworkspace
}
