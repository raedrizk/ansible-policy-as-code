package aap

import rego.v1

default github_only_repos := {
	"allowed": true,
	"violations": [],
}

# Check if the SCM URL contains github.com
is_github_repo if {
	contains(lower(input.project.scm_url), "github.com")
}

github_only_repos := {
	"allowed": false,
	"violations": [sprintf("Project repository '%v' is not from GitHub. Only github.com repositories are allowed", [input.project.scm_url])],
} if {
	input.project.scm_url != ""
	not is_github_repo
}
