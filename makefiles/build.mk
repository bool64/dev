GO ?= go

# Override in app Makefile to add custom ldflags, example BUILD_LDFLAGS=-s -w
BUILD_LDFLAGS ?=

# Override in app Makefile to add custom build flags, example BUILD_FLAGS=-trimpath -pgo=auto
BUILD_FLAGS ?= -trimpath

# Override in app Makefile to control build target, example BUILD_PKG=./cmd/my-app
BUILD_PKG ?= .

# Override in app Makefile to control build artifact destination.
BUILD_DIR ?= ./bin

## Build Linux binary
build-linux:
	@echo "Building Linux AMD64 binary, GOFLAGS: $(GOFLAGS)"
	@GOOS=linux GOARCH=amd64 $(GO) build $(BUILD_FLAGS) -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -o $(BUILD_DIR)/ $(BUILD_PKG)

## Build binary
build:
	@echo "Building binary, GOFLAGS: $(GOFLAGS)"
	@$(GO) build $(BUILD_FLAGS) -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -o $(BUILD_DIR)/ $(BUILD_PKG)

## Build and run binary
run:
	@echo "Running binary"
	@$(GO) run $(BUILD_FLAGS) -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" $(BUILD_PKG)

.PHONY: build-linux build run
