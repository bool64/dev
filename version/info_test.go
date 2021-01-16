package version

import (
	"fmt"
	"runtime"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestInformation_String(t *testing.T) {
	version = "v3.2.1"
	branch = ""
	revision = ""
	buildDate = ""
	buildUser = ""

	assert.Equal(t, "Version: v3.2.1, GoVersion: "+runtime.Version(), Info().String())

	version = "v1.2.3"
	branch = "refs/heads/master"
	revision = "111765232072440cc598b189e284c9a4450a6018"
	buildUser = "user"
	buildDate = "2021-01-13 22:13:41"

	assert.Equal(t, fmt.Sprintf("Version: %s, Revision: %s, Branch: %s, BuildUser: %s, BuildDate: %s, GoVersion: %s",
		version, revision, branch, buildUser, buildDate, runtime.Version()), Info().String())
}

func TestInformation_Values(t *testing.T) {
	version = "v3.2.1"
	branch = ""
	revision = ""
	buildDate = ""
	buildUser = ""

	assert.Equal(t, map[string]string{
		"branch": "", "build_date": "", "build_user": "", "go_version": runtime.Version(),
		"revision": "", "version": "v3.2.1",
	}, Info().Values())

	version = "v1.2.3"
	branch = "refs/heads/master"
	revision = "111765232072440cc598b189e284c9a4450a6018"
	buildDate = "2021-01-13 22:13:41"
	buildUser = "user"

	assert.Equal(t, map[string]string{
		"branch": branch, "build_date": buildDate, "build_user": buildUser,
		"go_version": runtime.Version(), "revision": revision, "version": version,
	}, Info().Values())
}
