action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cp $destdir/oonimkall.aar repo/probe-android/engine-experimental/
	run cd repo/probe-android
	run export ANDROID_HOME=$android_sdk
	run ./gradlew assembleExperimentalFullRelease
	local odir="./app/build/outputs/apk/experimentalFull/release"
	local oname="app-experimental-full-release-unsigned.apk"
	run mv $odir/$oname $destdir/app-unsigned.apk
}
