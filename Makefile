-include makefiles/help.mk

.PHONY: test

## Run tests
test:
	@echo "Running tests"
	@bash test.sh