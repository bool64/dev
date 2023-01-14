GO ?= go
BENCH_COUNT ?= 6
MASTER_BRANCH ?= master
REF_NAME ?= $(shell git symbolic-ref -q --short HEAD || git describe --tags --exact-match)
SHELL := /bin/bash

## Run benchmark and show result stats, iterations count controlled by BENCH_COUNT, default 5.
bench: bench-run bench-stat-diff bench-stat

bench-stat-cli:
	@test -s $(GOPATH)/bin/benchstat || GOFLAGS= GOBIN=$(GOPATH)/bin $(GO) install golang.org/x/perf/cmd/benchstat@latest

## Run benchmark, iterations count controlled by BENCH_COUNT, default 5.
bench-run:
	@set -o pipefail && $(GO) test -bench=. -count=$(BENCH_COUNT) -run=^a  ./... | tee bench-$(REF_NAME).txt

## Show benchmark comparison with base branch.
bench-stat-diff: bench-stat-cli
	@test ! -e bench-$(MASTER_BRANCH).txt || benchstat bench-$(MASTER_BRANCH).txt bench-$(REF_NAME).txt

## Show result of benchmark.
bench-stat: bench-stat-cli
	@$(GOPATH)/bin/benchstat bench-$(REF_NAME).txt

.PHONY: bench bench-run bench-stat-diff bench-stat
