action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cd repo/probe-android
	run export ANDROID_HOME=$android_sdk
	run ./gradlew assembleStableFullRelease
	local odir="./app/build/outputs/apk/stableFull/release"
	local oname="app-stable-full-release-unsigned.apk"
	run mv $odir/$oname $destdir/app-unsigned.apk
}
