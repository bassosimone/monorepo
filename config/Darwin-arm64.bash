#doc: # config/Darwin-arm64.bash
#doc:
#doc: This file contains darwin/arm64 specific settings.

#doc:
#doc: ### android_sdk (string)
#doc:
#doc: Location where to download the Android SDK. We use the directory
#doc: where Android Studio usually installs the SDK to avoid duplication.
android_sdk=$HOME/Library/Android/sdk

#doc:
#doc: ## golang_tarball (string)
#doc:
#doc: This is the name of the golang SDK tarball for this platform.
golang_tarball=go${golang_version}.darwin-arm64.tar.gz

#doc:
#doc: ## golang_sha256 (string)
#doc:
#doc: This is the SHA256 of the golang SDK tarball.
golang_sha256=40ecd383c941cc9f0682e6a6f2a333539d58c7dea15c842434d03afafe2f7242
