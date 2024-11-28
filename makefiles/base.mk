#GOLANGCI_LINT_VERSION := "v1.61.0" # Optional configuration to pinpoint golangci-lint version.

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
