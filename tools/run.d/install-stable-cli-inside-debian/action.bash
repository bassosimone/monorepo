action_main() {
	run docker run --platform=linux/amd64 -it -v$(pwd):/ooni \
		-w/ooni debian:stable \
		./tools/run.d/run-stable-cli-inside-debian/docker-main \
		amd64 /bin/bash
}
