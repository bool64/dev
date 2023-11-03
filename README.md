# Go development helpers

This library provides scripts and workflows to automate common routines with modular `Makefile` and GitHub Actions.

See [blog post](https://dev.to/vearutop/peace-of-mind-with-github-actions-for-a-project-in-go-9d4) for more information.

## Installation

### Automatic

Run this command in your repo root.
```
curl https://raw.githubusercontent.com/bool64/dev/master/makefiles/base.mk -sLo Makefile && printf "package $(go list -f '{{.Name}}' || echo 'mypackage')_test\n\nimport _ \"github.com/bool64/dev\" // Include CI/Dev scripts to project.\n" > dev_test.go && make reset-ci
```

### Manual

Add a test file (e.g. `dev_test.go`) to your module with unused import.

```go
package mymodule_test

import _ "github.com/bool64/dev" // Include development helpers to project. 
```

Add `Makefile` to your module with includes standard targets.

```Makefile
#GOLANGCI_LINT_VERSION := "v1.55.2" # Optional configuration to pinpoint golangci-lint version.

# The head of Makefile determines location of dev-go to include standard targets.
GO ?= go
export GO111MODULE = on

ifneq "$(GOFLAGS)" ""
  $(info GOFLAGS: ${GOFLAGS})
endif

ifneq "$(wildcard ./vendor )" ""
  $(info Using vendor)
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
    	DEVGO_PATH := $(shell export GO111MODULE=on && $(GO) get github.com/bool64/dev && $(GO) list -f '{{.Dir}}' -m github.com/bool64/dev)
	endif
endif

-include $(DEVGO_PATH)/makefiles/main.mk
-include $(DEVGO_PATH)/makefiles/lint.mk
-include $(DEVGO_PATH)/makefiles/test-unit.mk
-include $(DEVGO_PATH)/makefiles/bench.mk
-include $(DEVGO_PATH)/makefiles/reset-ci.mk

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

## Build Versioning

You can include `$(DEVGO_PATH)/makefiles/build.mk` to add automated versioning of build artifacts. Make will
configure `ldflags` to set up [version info](./version/info.go), then you can access it in runtime with `version.Info()`
or expose with [HTTP handler](./version/handler.go). Version information also includes versions of dependencies.
