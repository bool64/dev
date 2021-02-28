GO ?= go

-include $(DEVGO_PATH)/makefiles/github-actions.mk

## Reset CI files from bool64/dev templates, make sure to review changes before committing.
reset-ci: github-actions
	@cp $(DEVGO_PATH)/makefiles/base.mk Makefile; git add Makefile
	@cp $(DEVGO_PATH)/scripts/.golangci.yml .golangci.yml; git add .golangci.yml
	@echo "package $(shell go list -f '{{.Name}}')_test" > dev_test.go
	@echo "" >> dev_test.go
	@echo 'import _ "github.com/bool64/dev" // Include CI/Dev scripts to project.' >> dev_test.go

.PHONY: reset-ci
