#doc: # config/Linux-x86_64.bash
#doc:
#doc: This file contains linux/x86_64 specific settings.

#doc:
#doc: ### android_sdk (string)
#doc:
#doc: Location where to download the Android SDK. We use the directory
#doc: where Android Studio usually installs the SDK to avoid duplication.
android_sdk=$HOME/Android/Sdk

#doc:
#doc: ## golang_tarball (string)
#doc:
#doc: This is the name of the golang SDK tarball for this platform.
golang_tarball=go${golang_version}.linux-amd64.tar.gz

#doc:
#doc: ## golang_sha256 (string)
#doc:
#doc: This is the SHA256 of the golang SDK tarball.
golang_sha256=956f8507b302ab0bb747613695cdae10af99bbd39a90cae522b7c0302cc27245
