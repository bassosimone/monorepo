action_main() {
	local destdir="$(realpath ${workdir:-./output})"
	run cd repo/probe-cli

	run env GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 \
		go build -tags="ooni_psiphon_config" \
		-ldflags="-s -w" \
		-o $destdir/miniooni-darwin-amd64 \
		./internal/cmd/miniooni

	run env GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 \
		go build -tags="ooni_psiphon_config" \
		-ldflags="-s -w" \
		-o $destdir/miniooni-darwin-arm64 \
		./internal/cmd/miniooni

	run env GOOS=linux GOARCH=386 CGO_ENABLED=0 go build \
		-tags="netgo,ooni_psiphon_config" \
		-ldflags="-s -w -extldflags -static" \
		-o $destdir/miniooni-linux-386 \
		./internal/cmd/miniooni

	run env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
		go build -tags="netgo,ooni_psiphon_config" \
		-ldflags="-s -w -extldflags -static" \
		-o $destdir/miniooni-linux-amd64 \
		./internal/cmd/miniooni

	run env GOOS=linux GOARCH=arm CGO_ENABLED=0 GOARM=6 \
		go build -tags="netgo,ooni_psiphon_config" \
		-ldflags="-s -w -extldflags -static" \
		-o $destdir/miniooni-linux-armv6 \
		./internal/cmd/miniooni

	run env GOOS=linux GOARCH=arm CGO_ENABLED=0 GOARM=7 \
		go build -tags="netgo,ooni_psiphon_config" \
		-ldflags="-s -w -extldflags -static" \
		-o $destdir/miniooni-linux-armv7 \
		./internal/cmd/miniooni

	run env GOOS=linux GOARCH=arm64 CGO_ENABLED=0 \
		go build -tags="netgo,ooni_psiphon_config" \
		-ldflags="-s -w -extldflags -static" \
		-o $destdir/miniooni-linux-arm64 \
		./internal/cmd/miniooni

	run env GOOS=windows GOARCH=386 CGO_ENABLED=0 \
		go build -tags="ooni_psiphon_config" \
		-ldflags="-s -w" \
		-o $destdir/miniooni-windows-386.exe \
		./internal/cmd/miniooni

	run env GOOS=windows GOARCH=amd64 CGO_ENABLED=0 \
		go build -tags="ooni_psiphon_config" \
		-ldflags="-s -w" \
		-o $destdir/miniooni-windows-amd64.exe \
		./internal/cmd/miniooni

	run env GOOS=windows GOARCH=arm64 CGO_ENABLED=0 \
		go build -tags="ooni_psiphon_config" \
		-ldflags="-s -w" \
		-o $destdir/miniooni-windows-arm64.exe \
		./internal/cmd/miniooni
}
