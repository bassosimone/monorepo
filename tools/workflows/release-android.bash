workflow_info() {
	echo "builds unsigned stable-full android app release"
}

workflow_run() {
	if [[ -z "${ANDROID_HOME+x}" ]]; then
		echo "fatal: ANDROID_HOME is not set" 1>&2
		exit 1
	fi
    run ./tools/run dev-android-keystore
	local android="./repo/probe-android"
	local name_unsigned="ooniprobe-unsigned.apk"
	local name_aligned="ooniprobe-unsigned-aligned.apk"
	local name_signed="ooniprobe.apk"
	(
		run cd output
		run rm -f $name_unsigned $name_aligned $name_signed
	)
	(
		run cd $android
		run ./gradlew assembleStableFullRelease
		local output="./app/build/outputs/apk/stableFull/release"
		local oname="app-stable-full-release-unsigned.apk"
		run mv $output/$oname ../../output/$name_unsigned
	)
	(
		run cd output
		export PATH=$ANDROID_HOME/build-tools/$android_build_tools_version:$PATH
		run zipalign -p 4 $name_unsigned $name_aligned
		run apksigner sign --ks $android_efr_keystore --out $name_signed \
			--ks-pass pass:$android_efr_keystore_password $name_aligned
	)
}
