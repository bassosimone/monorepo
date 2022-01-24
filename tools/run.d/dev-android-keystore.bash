workflow_info() {
	echo "generates a self-signed key for signing experimental releases"
}

# TODO: this workflow should be an action

workflow_run() {
	local ksfile=./output/$android_efr_keystore
	if [[ -f $ksfile ]]; then
		return
	fi
	run printf "${android_efr_keystore_password}\n${android_efr_keystore_password}\n\n\n\n\n\n\nyes\n" |
		run keytool -genkey -v -keystore $ksfile \
			-keyalg RSA -keysize 2048 \
			-validity $android_efr_keystore_validity \
			-alias $android_efr_keystore_keyalias
}
