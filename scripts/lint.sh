#!/usr/bin/env bash

[ -z "$GO" ] && GO=go
[ -z "$GOLANGCI_LINT_VERSION" ] && GOLANGCI_LINT_VERSION="v2.15.0"

# detecting GOPATH and removing trailing "/" if any
GOPATH="$(go env GOPATH)"
GOPATH=${GOPATH%/}

# adding GOBIN to PATH
[[ ":$PATH:" != *"$GOPATH/bin"* ]] && PATH=$PATH:"$GOPATH"/bin

# checking if golangci-lint is available
if ! command -v golangci-lint-"$GOLANGCI_LINT_VERSION" >/dev/null; then
  echo "Installing golangci-lint $GOLANGCI_LINT_VERSION..."
  tmp=$(mktemp -d)
  ver=${GOLANGCI_LINT_VERSION#v}
  name=golangci-lint-$ver-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
  url=https://github.com/golangci/golangci-lint/releases/download/$GOLANGCI_LINT_VERSION
  curl -sSfL "$url/$name.tar.gz" -o "$tmp/$name.tar.gz" &&
    curl -sSfL "$url/golangci-lint-$ver-checksums.txt" -o "$tmp/sums" &&
    # anchored match: checksums also list "$name.tar.gz.sbom.json" since v2.15.0
    want=$(grep -F " $name.tar.gz" "$tmp/sums" | grep -v sbom | awk '{print $1}') &&
    [ "$(shasum -a 256 "$tmp/$name.tar.gz" | awk '{print $1}')" = "$want" ] &&
    tar -xzf "$tmp/$name.tar.gz" -C "$tmp" &&
    mv "$tmp/$name/golangci-lint" "$GOPATH"/bin/golangci-lint-"$GOLANGCI_LINT_VERSION"
  rm -rf "$tmp"
fi

this_path=$(dirname "$0")

golangci_yml="./.golangci.yml"
if [ ! -f "./.golangci.yml" ]; then
  golangci_yml="$this_path"/.golangci.yml
fi

echo "Checking packages."
golangci-lint-"$GOLANGCI_LINT_VERSION" run -c "$golangci_yml" ./... || exit 1
