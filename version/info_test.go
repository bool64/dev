package version

import (
	"fmt"
	"runtime"
	"testing"
)

func TestInformation_String(t *testing.T) {
	version = "v3.2.1"
	branch = ""
	revision = ""
	buildDate = ""
	buildUser = ""

	equal(t, "Version: v3.2.1, GoVersion: "+runtime.Version(), Info().String())

	version = "v1.2.3"
	branch = "refs/heads/master"
	revision = "111765232072440cc598b189e284c9a4450a6018"
	buildUser = "user"
	buildDate = "2021-01-13 22:13:41"

	expected := fmt.Sprintf("Version: %s, Revision: %s, Branch: %s, BuildUser: %s, BuildDate: %s, GoVersion: %s",
		version, revision, branch, buildUser, buildDate, runtime.Version())
	received := Info().String()

	equal(t, expected, received)
}

func TestInformation_Values(t *testing.T) {
	version = "v3.2.1"
	branch = ""
	revision = ""
	buildDate = ""
	buildUser = ""

	equal(t, fmt.Sprintf("%v", map[string]string{
		"branch": "", "build_date": "", "build_user": "", "go_version": runtime.Version(),
		"revision": "", "version": "v3.2.1",
	}), fmt.Sprintf("%v", Info().Values()))

	version = "v1.2.3"
	branch = "refs/heads/master"
	revision = "111765232072440cc598b189e284c9a4450a6018"
	buildDate = "2021-01-13 22:13:41"
	buildUser = "user"

	equal(t, fmt.Sprintf("%v", map[string]string{
		"branch": branch, "build_date": buildDate, "build_user": buildUser,
		"go_version": runtime.Version(), "revision": revision, "version": version,
	}), fmt.Sprintf("%v", Info().Values()))

	expected := fmt.Sprintf("%v", map[string]string{
		"branch": branch, "build_date": buildDate, "build_user": buildUser,
		"go_version": runtime.Version(), "revision": revision, "version": version,
	})

	received := fmt.Sprintf("%v", Info().Values())

	equal(t, expected, received)
}

func equal(t *testing.T, expected, received string) {
	t.Helper()

	if expected != received {
		t.Fatalf("%q is expected, %s received", expected, received)
	}
}
