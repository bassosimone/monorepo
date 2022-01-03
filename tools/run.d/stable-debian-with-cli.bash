workflow_info() {
	echo "runs the stable CLI inside a linux/amd64 debian container"
}

workflow_run() {
	run docker run --platform=linux/amd64 -it -v$(pwd):/ooni \
		-w/ooni debian:stable ./docker/debian-stable-cli amd64 /bin/bash
}
