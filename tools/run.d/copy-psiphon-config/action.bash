action_main() {
	if [[ "${ooni_psiphon_config}" == "" ]]; then
		# do nothing when there's no need to copy files
		return
	fi
	local src=./repo/probe-private
	local dest=./repo/probe-cli/internal/engine
	run cp $src/psiphon-config.json.age $dest/
	run cp $src/psiphon-config.key $dest/
}
