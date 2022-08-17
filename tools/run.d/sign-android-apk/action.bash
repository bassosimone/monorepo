action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	android_home=$(cd ./repo/probe-cli && ./MOBILE/android/home)
	run cd $destdir
	apksigner=$(find $android_home/build-tools -type f -name apksigner|head -n1)
	zipalign=$(find $android_home/build-tools -type f -name zipalign|head -n1)
	run rm -f app-unsigned-aligned.apk
	run $zipalign -p 4 app-unsigned.apk app-unsigned-aligned.apk
	run rm -f app.apk
	run $apksigner sign --ks keystore.jks --out app.apk \
		--ks-pass pass:$android_efr_keystore_password app-unsigned-aligned.apk
}
