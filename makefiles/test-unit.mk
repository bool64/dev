GO ?= go
UNIT_TEST_COUNT ?= 2

## Run unit tests
test-unit:
	@echo "Running unit tests."
	@$(GO) test -gcflags=-l -coverprofile=unit.coverprofile -covermode=atomic -race ./...

## Run unit tests multiple times
test-unit-multi:
	@echo "Running unit tests ${UNIT_TEST_COUNT} times."
	@$(GO) test -gcflags=-l -coverprofile=unit.coverprofile -count $(UNIT_TEST_COUNT) -covermode=atomic -race ./...

.PHONY: test-unit test-unit-multi
