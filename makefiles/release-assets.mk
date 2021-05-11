GO ?= go

# Override in app Makefile to add custom ldflags, example BUILD_LDFLAGS="-s -w"
BUILD_LDFLAGS ?= ""

# Override in app Makefile to control build target, example BUILD_PKG=./cmd/my-app
BUILD_PKG ?= .

# Override in app Makefile to control build artifact destination.
BUILD_DIR ?= ./bin

export CGO_ENABLED ?= 0

## Build and compress binaries for release assets.
release-assets:
	@echo "Building Darwin AMD64 binary"
	@GOOS=darwin GOARCH=amd64 $(GO) build -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -o $(BUILD_DIR)/ $(BUILD_PKG) && cd $(BUILD_DIR) && tar zcvf ../darwin_amd64.tar.gz * && rm *
	@echo "Building Darwin ARM64 binary"
	@GOOS=darwin GOARCH=arm64 $(GO) build -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -o $(BUILD_DIR)/ $(BUILD_PKG) && cd $(BUILD_DIR) && tar zcvf ../darwin_arm64.tar.gz * && rm *
	@echo "Building Linux AMD64 binary"
	@GOOS=linux GOARCH=amd64 $(GO) build -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -o $(BUILD_DIR)/ $(BUILD_PKG) && cd $(BUILD_DIR) && tar zcvf ../linux_amd64.tar.gz * && rm *
	@echo "Building Linux ARM64 binary"
	@GOOS=linux GOARCH=arm64 $(GO) build -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -o $(BUILD_DIR)/ $(BUILD_PKG) && cd $(BUILD_DIR) && tar zcvf ../linux_arm64.tar.gz * && rm *
	@echo "Building Linux ARM binary"
	@GOOS=linux GOARCH=arm $(GO) build -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -o $(BUILD_DIR)/ $(BUILD_PKG) && cd $(BUILD_DIR) && tar zcvf ../linux_arm.tar.gz * && rm *
	@echo "Building Windows AMD64 binary"
	@GOOS=windows GOARCH=amd64 $(GO) build -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -o $(BUILD_DIR)/ $(BUILD_PKG) && cd $(BUILD_DIR) && zip -9 -j ../windows_amd64.zip * && rm *

.PHONY: build-release
