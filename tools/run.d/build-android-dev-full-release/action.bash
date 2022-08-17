action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run export ANDROID_HOME=$(cd ./repo/probe-cli && ./MOBILE/android/home)
	run cd repo/probe-android
	run ./gradlew assembleDevFullRelease
	local odir="./app/build/outputs/apk/devFull/release"
	local oname="app-dev-full-release-unsigned.apk"
	run mv $odir/$oname $destdir/app-unsigned.apk
}
