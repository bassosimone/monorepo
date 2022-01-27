action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cd repo/probe-android
	run export ANDROID_HOME=$android_sdk
	run ./gradlew assembleDevFullRelease
	local odir="./app/build/outputs/apk/devFull/release"
	local oname="app-dev-full-release-unsigned.apk"
	run mv $odir/$oname $destdir/app-unsigned.apk
}
