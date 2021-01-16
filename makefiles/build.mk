GO ?= go
BUILD_LDFLAGS ?= ""
BUILD_PKG ?= .
BUILD_DIR ?= ./bin

## Build Linux binary
build-linux:
	@echo "Building Linux AMD64 binary, GOFLAGS: $(GOFLAGS)"
	@GOOS=linux GOARCH=amd64 $(GO) build -ldflags "$(BUILD_LDFLAGS)" -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh)" -o $(BUILD_DIR)/ $(BUILD_PKG)

## Build binary
build:
	@echo "Building binary, GOFLAGS: $(GOFLAGS)"
	@$(GO) build -ldflags "$(BUILD_LDFLAGS)" -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh)" -o $(BUILD_DIR)/ $(BUILD_PKG)

## Build and run binary
run:
	@echo "Running binary"
	@$(GO) run -ldflags "$(BUILD_LDFLAGS)$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh)" $(BUILD_PKG)

.PHONY: build-linux build run
