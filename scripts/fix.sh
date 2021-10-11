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
    $GO install github.com/vasi-stripe/gogroup/cmd/gogroup@v0.0.0-20200806161525-b5d7f67a97b5;
fi

gogroup -order std,other -rewrite ${SOURCES_TO_LINT}

# checking if gofumpt is available
# gofumpt is a drop-in replacement for gofmt with stricter formatting: https://github.com/mvdan/gofumpt
if ! command -v gofumpt > /dev/null ; then \
    echo "Installing gofumpt..."; \
    $GO install mvdan.cc/gofumpt@4d8e76d698e7e061266253df920ef5b28d8f8f13;
fi

# simplify code
gofumpt -w ${SOURCES_TO_LINT}