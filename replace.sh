#!/usr/bin/env bash
set -e

# Replace template with actual repo data.
url=$(git remote get-url origin)

url_nopro=${url#*//}
url_noatsign=${url_nopro#*@}

gh_repo=${url_noatsign#"github.com:"}
gh_repo=${gh_repo#"github.com/"}
gh_repo=${gh_repo%".git"}

project_name=$(basename $gh_repo)

echo "## Replacing all bool64/go-template references by $project_name"
find ./.github -type f -print0 | xargs -0 perl -i -pe "s|bool64/go-template|$gh_repo|g"
find ./.github -type f -print0 | xargs -0 perl -i -pe "s|go-template|$project_name|g"

