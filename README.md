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
#GOLANGCI_LINT_VERSION := "v2.5.0" # Optional configuration to pinpoint golangci-lint version.

# MODULES is a list of dev modules (mk) to be included in the project.
MODULES := \
	DEVGO_PATH=github.com/bool64/dev

# The head of Makefile determines location of dev-go to include standard targets.
GO ?= go
export GO111MODULE = on

ifneq "$(GOFLAGS)" ""
  $(info GOFLAGS: ${GOFLAGS})
endif

# Use vendored dependencies if available.
ifneq ($(wildcard ./vendor),)
  modVendor := -mod=vendor
  ifeq (,$(findstring -mod,$(GOFLAGS)))
      export GOFLAGS := ${GOFLAGS} ${modVendor}
  endif
endif

# Set dev module paths or download them.
$(foreach module,$(MODULES), \
	$(eval key=$(word 1,$(subst =, ,$(module)))); \
	$(eval value=$(word 2,$(subst =, ,$(module)))); \
	\
	$(if $(wildcard ./vendor/$(value)), \
		$(eval export $(key)=./vendor/$(value)); \
	) \
	\
	$(if $(strip $($(key))), , \
    	$(eval export $(key)=$(shell GO111MODULE=on $(GO) list ${modVendor} -f '{{.Dir}}' -m $(value))); \
		$(if $(strip $($(key))), \
			$(info Module $(value) not found, downloading.); \
			$(eval export $(key)=$(shell export GO111MODULE=on && $(GO) get $(value) && $(GO) list -f '{{.Dir}}' -m $(value))); \
		) \
    ) \
)

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

## Create Plugins

You can add plugins for your project and include them in the Makefile. For example, you can add a plugin 
to run `protoc` targets which is place it in `github/<owner>/<repo>/makefiles/protoc.mk`. 

Then include it in the Makefile:

```Makefile
# MODULES is a list of dev modules (mk) to be included in the project.
MODULES := \
	DEVGO_PATH=github.com/bool64/dev \
	DEVGRPCGO_PATH=github/<owner>/<repo>/makefiles/protoc.mk

  ...	
	
-include $(DEVGO_PATH)/makefiles/bench.mk
-include $(DEVGO_PATH)/makefiles/reset-ci.mk

-include $(DEVGRPCGO_PATH)/makefiles/protoc.mk
```

Then add `github/<owner>/<repo>` to your module with unused import defined in `dev_test.go`:

```go
package mymodule_test

import (
    _ "github.com/bool64/dev" // Include development helpers to project.
    _ "github.com/<owner>/<repo>" // Include custom plugins to project.
)
```

`DEVGRPCGO_PATH` is a path to the plugin module. It will be the path to the remote repository. 

### Plugin Structure

The plugin should have the following structure:

```makefile
GO ?= go

PWD ?= $(shell pwd)

DEVGRPCGO_PATH ?= $(PWD)/vendor/github.com/<owner>/<repo>
DEVGRPCGO_SCRIPTS ?= $(DEVGRPCGO_PATH)/scripts # In case there is a scripts directory.

## Check/install protoc tool
protoc-cli:
	@bash $(DEVGRPC_SCRIPTS)/protoc-gen-cli.sh


.PHONY: protoc-cli
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
  protoc-cli:           Check/install protoc tool
```