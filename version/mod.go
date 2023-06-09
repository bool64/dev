//go:build go1.12
// +build go1.12

package version

import (
	"fmt"
	"runtime/debug"
)

//nolint:gochecknoinits
func init() {
	if info, available := debug.ReadBuildInfo(); available {
		if version == "dev" && info.Main.Version != "(devel)" && info.Main.Version != "" {
			version = info.Main.Version
			revision = fmt.Sprintf("(unknown, mod sum: %q)", info.Main.Sum)
			buildUser = "(unknown)"
			buildDate = "(unknown)"
		}

		main = info.Main.Path

		dependencies = make(map[string]string, len(info.Deps))
		for _, dep := range info.Deps {
			dependencies[dep.Path] = dep.Version
		}
	}
}
