GO ?= go

## Run unit tests
test-unit:
	@echo "Running unit tests."
	@$(GO) test -gcflags=-l -coverprofile=unit.coverprofile -count 5 -covermode=atomic -race ./...

.PHONY: test-unit
