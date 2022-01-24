workflow_info() {
	echo "builds oonimkall.aar and creates experimental-full-release .apk using it"
}

# TODO: this workflow should be split into actions

workflow_run() {
	run ./tools/run dev-android-keystore
	run ./tools/run release-oonimkall-android
	local android="./repo/probe-android"
	run cp ./output/oonimkall.aar $android/engine-experimental/
	local name_unsigned="ooniprobe-efr-unsigned.apk"
	local name_aligned="ooniprobe-efr-unsigned-aligned.apk"
	local name_signed="ooniprobe-efr.apk"
	(
		run cd output
		run rm -f $name_unsigned $name_aligned $name_signed
	)
	(
		run cd $android
		run export ANDROID_HOME=$android_sdk
		run ./gradlew assembleExperimentalFullRelease
		local output="./app/build/outputs/apk/experimentalFull/release"
		local oname="app-experimental-full-release-unsigned.apk"
		run mv $output/$oname ../../output/$name_unsigned
	)
	(
		run cd output
		run export PATH=$android_sdk/build-tools/$android_build_tools_version:$PATH
		run zipalign -p 4 $name_unsigned $name_aligned
		run apksigner sign --ks $android_efr_keystore --out $name_signed \
			--ks-pass pass:$android_efr_keystore_password $name_aligned
	)
}
