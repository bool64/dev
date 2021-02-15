GO ?= go
BENCH_COUNT ?= 5
MASTER_BRANCH ?= master
REF_NAME ?= $(shell git symbolic-ref -q --short HEAD || git describe --tags --exact-match)

## Run benchmark and show result stats, iterations count controlled by BENCH_COUNT, default 5.
bench: bench-run bench-stat

## Run benchmark, iterations count controlled by BENCH_COUNT, default 5.
bench-run:
	@$(GO) test -bench=. -count=$(BENCH_COUNT) -run=^a  ./... >bench-$(REF_NAME).txt || (cat bench-$(REF_NAME).txt && exit 1)

## Show result of benchmark.
bench-stat:
	@test -s $(GOPATH)/bin/benchstat || GO111MODULE=off GOFLAGS= GOBIN=$(GOPATH)/bin $(GO) get -u golang.org/x/perf/cmd/benchstat
	@test -e bench-$(MASTER_BRANCH).txt && benchstat bench-$(MASTER_BRANCH).txt bench-$(REF_NAME).txt || $(GOPATH)/bin/benchstat bench-$(REF_NAME).txt

.PHONY: bench bench-run bench-stat
