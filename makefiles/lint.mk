GO ?= go

## Check with golangci-lint
lint:
	@DEVGO_PATH=$(DEVGO_PATH) GOLANGCI_LINT_VERSION=$(GOLANGCI_LINT_VERSION) bash $(DEVGO_SCRIPTS)/lint.sh

## Apply goimports and gofmt
fix-lint:
	@DEVGO_PATH=$(DEVGO_PATH) bash $(DEVGO_SCRIPTS)/fix.sh

.PHONY: lint fix-lint
