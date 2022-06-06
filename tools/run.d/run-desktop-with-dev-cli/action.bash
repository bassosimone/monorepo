action_main() {
	local goos=""
	case "$(uname -s)" in
	"Linux")
		goos="linux"
		;;
	"Darwin")
		goos="darwin"
		;;
	*)
		fatal "This command only works on Linux and Darwin"
		;;
	esac

	local target=""
	local goarch=""
	case "$(uname -m)" in
	"x86_64")
		goarch="amd64"
		target="${goos}_${goarch}"
		;;
	"arm64")
		if [[ $goos != "darwin" ]]; then
			fatal "This command requires amd64 or darwin/arm64"
		fi
		# There is no ooniprobe-desktop for darwin/arm64 but darwin/arm64 can run amd64
		# so we are cheating by compiling ooniprobe-cli for arm64 and we need to have node
		# installed for amd64 for this build to actually work.
		#
		# If you do not have this weird setup, it's quite likely that the electron build
		# will fail, and you'll probably come here and read this comment.
		#
		# TODO(bassosimone): it would be cool to have ooniprobe-desktop for darwin/arm64.
		target="${goos}_amd64"
		goarch="arm64"
		;;
	*)
		fatal "This command requires linux/{amd,arm}64 or darwin/{amd,arm}64"
		;;
	esac

	local cli="./repo/probe-cli"
	local desktop="./repo/probe-desktop"
	run mkdir -p $desktop/build/probe-cli/$target

	(
		run cd $cli
		# TODO(bassosimone): add support for psiphon
		run $golang_go build -ldflags "-s -w" ./cmd/ooniprobe
	)

	run cp -p $cli/ooniprobe $desktop/build/probe-cli/$target
	(
		run cd repo/probe-desktop
		run yarn install
		run yarn dev
	)
}
