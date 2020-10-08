GO ?= go
UNIT_TEST_COUNT ?= 5

## Run unit tests
test-unit:
	@echo "Running unit tests."
	@$(GO) test -gcflags=-l -coverprofile=unit.coverprofile -count $(UNIT_TEST_COUNT) -covermode=atomic -race ./...

.PHONY: test-unit
