setup_psiphon_depends() {
	echo ""
}

setup_psiphon_main() {
	local src=./repo/probe-private
	local dest=./repo/probe-cli/internal/engine
	run cp $src/psiphon-config.json.age $dest/
	run cp $src/psiphon-config.key $dest/
}
