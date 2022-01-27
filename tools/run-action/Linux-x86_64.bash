# TODO: these checks should only be performed when needed
function setup_defaults_platform_main() {
	require_commands docker qemu-aarch64-static
	require_commands x86_64-w64-mingw32-gcc i686-w64-mingw32-gcc
}
