action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run printf "${android_efr_keystore_password}\n${android_efr_keystore_password}\n\n\n\n\n\n\nyes\n" |
		run keytool -genkey -v -keystore $destdir/keystore.jks \
			-keyalg RSA -keysize 2048 \
			-validity $android_efr_keystore_validity \
			-alias $android_efr_keystore_keyalias
}
