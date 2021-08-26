GO ?= go
BENCH_COUNT ?= 5
MASTER_BRANCH ?= master
REF_NAME ?= $(shell git symbolic-ref -q --short HEAD || git describe --tags --exact-match)

## Run benchmark and show result stats, iterations count controlled by BENCH_COUNT, default 5.
bench: bench-run bench-stat-diff bench-stat

## Run benchmark, iterations count controlled by BENCH_COUNT, default 5.
bench-run:
	@set -o pipefail && $(GO) test -bench=. -count=$(BENCH_COUNT) -run=^a  ./... | tee bench-$(REF_NAME).txt

## Show benchmark comparison with base branch.
bench-stat-diff:
	@test -s $(GOPATH)/bin/benchstat || GO111MODULE=off GOFLAGS= GOBIN=$(GOPATH)/bin $(GO) get -u golang.org/x/perf/cmd/benchstat
	@test -e bench-$(MASTER_BRANCH).txt && benchstat bench-$(MASTER_BRANCH).txt bench-$(REF_NAME).txt

## Show result of benchmark.
bench-stat:
	@test -s $(GOPATH)/bin/benchstat || GO111MODULE=off GOFLAGS= GOBIN=$(GOPATH)/bin $(GO) get -u golang.org/x/perf/cmd/benchstat
	@$(GOPATH)/bin/benchstat bench-$(REF_NAME).txt

.PHONY: bench bench-run bench-stat-diff bench-stat
