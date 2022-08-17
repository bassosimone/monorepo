action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cd repo/probe-cli
	run make ./MOBILE/android/oonimkall.aar
	run mv ./MOBILE/android/oonimkall.aar $destdir
}
