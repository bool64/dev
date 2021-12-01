GO ?= go
UNIT_TEST_COUNT ?= 2

## Run unit tests
test-unit:
	@echo "Running unit tests."
	@CGO_ENABLED=1 $(GO) test -short -coverprofile=unit.coverprofile -covermode=atomic -race ./...

## Run unit tests multiple times, use `UNIT_TEST_COUNT=10 make test-unit-multi` to control count
test-unit-multi:
	@echo "Running unit tests ${UNIT_TEST_COUNT} times."
	@CGO_ENABLED=1 $(GO) test -short -coverprofile=unit.coverprofile -count $(UNIT_TEST_COUNT) -covermode=atomic -race ./...

.PHONY: test-unit test-unit-multi
