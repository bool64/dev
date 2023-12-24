GO ?= go

# Override in app Makefile to add custom ldflags, example BUILD_LDFLAGS="-s -w"
BUILD_LDFLAGS ?= ""

# Override in app Makefile to control build target, example BUILD_PKG=./cmd/my-app
BUILD_PKG ?= .

# Override in app Makefile to control build artifact destination.
BUILD_DIR ?= ./bin

RELEASE_TARGETS ?= "darwin/amd64 darwin/arm64 linux/amd64 linux/arm64 linux/arm32 windows/amd64"

## Build and compress binaries for release assets.
release-assets:
	@echo "Release targets: $(RELEASE_TARGETS)"
	@GO=$(GO) RELEASE_TARGETS=$(RELEASE_TARGETS) BUILD_DIR=$(BUILD_DIR) DEVGO_SCRIPTS=$(DEVGO_SCRIPTS) BUILD_PKG=$(BUILD_PKG) bash $(DEVGO_SCRIPTS)/release-assets.sh

.PHONY: release-assets
