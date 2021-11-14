#!/usr/bin/env bash

[ -z "$GO" ] && GO=go
[ -z "$GOLANGCI_LINT_VERSION" ] && GOLANGCI_LINT_VERSION="v1.43.0"

# detecting GOPATH and removing trailing "/" if any
GOPATH="$(go env GOPATH)"
GOPATH=${GOPATH%/}

# adding GOBIN to PATH
[[ ":$PATH:" != *"$GOPATH/bin"* ]] && PATH=$PATH:"$GOPATH"/bin

# checking if golangci-lint is available
if ! command -v golangci-lint-"$GOLANGCI_LINT_VERSION" >/dev/null; then
  echo "Installing golangci-lint $GOLANGCI_LINT_VERSION..."
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /tmp "$GOLANGCI_LINT_VERSION" && mv /tmp/golangci-lint "$GOPATH"/bin/golangci-lint-"$GOLANGCI_LINT_VERSION"
fi

this_path=$(dirname "$0")

golangci_yml="./.golangci.yml"
if [ ! -f "./.golangci.yml" ]; then
  golangci_yml="$this_path"/.golangci.yml
fi

echo "Checking packages."
golangci-lint-"$GOLANGCI_LINT_VERSION" run -c "$golangci_yml" ./... || exit 1

if [[ -d "./internal" && -d "./cmd" ]]; then
  echo "Checking unused exported symbols in internal packages."
  golangci-lint-"$GOLANGCI_LINT_VERSION" run -c "$this_path"/.golangci-internal.yml ./internal/... ./cmd/... || exit 1
fi
