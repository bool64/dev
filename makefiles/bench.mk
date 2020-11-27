GO ?= go
BENCH_COUNT ?= 5
MASTER_BRANCH ?= master

## Run benchmark, iterations count controlled by BENCH_COUNT, default 5.
bench:
	@$(GO) test -bench=. -count=$(BENCH_COUNT) -run=^a  ./... >bench-$(REF_NAME).txt
	@test -s $(GOPATH)/bin/benchstat || GO111MODULE=off GOFLAGS= GOBIN=$(GOPATH)/bin $(GO) get -u golang.org/x/perf/cmd/benchstat
	@test -e bench-$(MASTER_BRANCH).txt && benchstat bench-$(MASTER_BRANCH).txt bench-$(REF_NAME).txt || $(GOPATH)/bin/benchstat bench-$(REF_NAME).txt

.PHONY: bench
