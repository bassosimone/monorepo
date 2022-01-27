action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cd $destdir
	run export PATH=$android_sdk/build-tools/$android_build_tools_version:$PATH
	run zipalign -p 4 app-unsigned.apk app-unsigned-aligned.apk
	run apksigner sign --ks keystore.jks --out app.apk \
		--ks-pass pass:$android_efr_keystore_password app-unsigned-aligned.apk
}
