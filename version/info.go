// Package version contains build information.
package version

import "runtime"

// Build information. Populated at build-time.
// nolint:gochecknoglobals
var (
	version      = "dev"
	revision     string
	branch       string
	buildUser    string
	buildDate    string
	dependencies map[string]string
	main         string
)

// Information holds app version info.
type Information struct {
	Version      string            `json:"version,omitempty"`
	Revision     string            `json:"revision,omitempty"`
	Branch       string            `json:"branch,omitempty"`
	BuildUser    string            `json:"build_user,omitempty"`
	BuildDate    string            `json:"build_date,omitempty"`
	GoVersion    string            `json:"go_version,omitempty"`
	Dependencies map[string]string `json:"dependencies,omitempty"`
}

// Info returns app version info.
func Info() Information {
	return Information{
		Version:      version,
		Revision:     revision,
		Branch:       branch,
		BuildUser:    buildUser,
		BuildDate:    buildDate,
		GoVersion:    runtime.Version(),
		Dependencies: dependencies,
	}
}

// Module returns module version info.
func Module(path string) Information {
	info := Info()

	if main == path {
		return info
	}

	ver := dependencies[path]
	info.Version = ver

	return info
}

// String return version information as string.
func (i Information) String() string {
	res := ""

	if i.Version != "" {
		res += ", Version: " + i.Version
	}

	if i.Revision != "" {
		res += ", Revision: " + i.Revision
	}

	if i.Branch != "" {
		res += ", Branch: " + i.Branch
	}

	if i.BuildUser != "" {
		res += ", BuildUser: " + i.BuildUser
	}

	if i.BuildDate != "" {
		res += ", BuildDate: " + i.BuildDate
	}

	res += ", GoVersion: " + runtime.Version()

	return res[2:]
}

// Values return version information as string map.
func (i Information) Values() map[string]string {
	return map[string]string{
		"version":    i.Version,
		"revision":   i.Revision,
		"branch":     i.Branch,
		"build_user": i.BuildUser,
		"build_date": i.BuildDate,
		"go_version": i.GoVersion,
	}
}
