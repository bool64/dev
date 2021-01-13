# Go development helpers

## Usage

Add a test file (e.g. `dev_test.go`) to your module with unused import.
```go
package mymodule_test

import _ "github.com/bool64/dev" // Include development helpers to project. 
```

Add `Makefile` to your module with includes standard targets.
```Makefile
GOLANGCI_LINT_VERSION := "v1.35.2" # Optional.

# The head of Makefile determines location of dev-go to include standard targets.
GO ?= go
export GO111MODULE = on

ifneq "$(GOFLAGS)" ""
  $(info GOFLAGS: ${GOFLAGS})
endif

ifneq "$(wildcard ./vendor )" ""
  $(info >> using vendor)
  modVendor =  -mod=vendor
  ifeq (,$(findstring -mod,$(GOFLAGS)))
      export GOFLAGS := ${GOFLAGS} ${modVendor}
  endif
  ifneq "$(wildcard ./vendor/github.com/bool64/dev)" ""
  	DEVGO_PATH := ./vendor/github.com/bool64/dev
  endif
endif

ifeq ($(DEVGO_PATH),)
	DEVGO_PATH := $(shell GO111MODULE=on $(GO) list ${modVendor} -f '{{.Dir}}' -m github.com/bool64/dev)
	ifeq ($(DEVGO_PATH),)
    	$(info Module github.com/bool64/dev not found, downloading.)
    	DEVGO_PATH := $(shell export GO111MODULE=on && $(GO) mod tidy && $(GO) list -f '{{.Dir}}' -m github.com/bool64/dev)
	endif
endif

-include $(DEVGO_PATH)/makefiles/main.mk
-include $(DEVGO_PATH)/makefiles/lint.mk
-include $(DEVGO_PATH)/makefiles/test-unit.mk
-include $(DEVGO_PATH)/makefiles/bench.mk
-include $(DEVGO_PATH)/makefiles/github-actions.mk

# Add your custom targets here.

## Run tests
test: test-unit

```

Then `make` will have these targets:
```
Usage
  test:                 Run tests
  test-unit:            Run unit tests
  test-unit-multi:      Run unit tests multiple times
  lint:                 Check with golangci-lint
  fix-lint:             Apply goimports and gofmt
  bench:                Run benchmark, iterations count controlled by BENCH_COUNT, default 5.
  github-actions:       Replace GitHub Actions from template

```