// Package dev contains reusable development helpers.
package dev

// These imports workaround `go mod vendor` prune.
//
// See https://github.com/golang/go/issues/26366.
import (
	_ "github.com/bool64/dev/makefiles"
	_ "github.com/bool64/dev/scripts"
	_ "github.com/bool64/dev/templates/github/workflows"
)
