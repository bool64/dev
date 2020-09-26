#!/usr/bin/env bash

[ -z "$GOBIN" ] && GOBIN=$(go env GOPATH)/bin
[[ ":$PATH:" != *":$GOBIN:"* ]] && PATH="${GOBIN}:${PATH}"

echo "Fixing imports and fmt..."

[ -z "$GO" ] && GO=go
SOURCES_TO_LINT=$(find . -name '*.go' -not -path "./vendor/*")

# checking if gogroup is available
# gogroup enforces import grouping: https://github.com/vasi-stripe/gogroup
if ! command -v gogroup > /dev/null ; then \
    echo "Installing gogroup..."; \
    bash -c "cd /tmp;GO111MODULE=on $GO get github.com/vasi-stripe/gogroup/cmd/gogroup@v0.0.0-20200806161525-b5d7f67a97b5";
fi

gogroup -order std,other -rewrite ${SOURCES_TO_LINT}

# checking if gofumpt is available
# gofumpt is a drop-in replacement for gofmt with stricter formatting: https://github.com/mvdan/gofumpt
if ! command -v gofumpt > /dev/null ; then \
    echo "Installing gofumpt..."; \
    bash -c "cd /tmp;GO111MODULE=on $GO get mvdan.cc/gofumpt@v0.0.0-20200802201014-ab5a8192947d";
fi

# simplify code
gofumpt -s -w ${SOURCES_TO_LINT} &>/dev/null