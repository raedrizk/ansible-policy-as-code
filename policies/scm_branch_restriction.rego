package aap

import rego.v1

default scm_branch_restriction := {
	"allowed": true,
	"violations": [],
}

# Define allowed branch patterns
allowed_branches := ["main"]

allowed_branch_prefixes := ["feature/", "release/"]

# Check if branch is allowed
is_allowed_branch(branch) if {
	branch in allowed_branches
}

is_allowed_branch(branch) if {
	some prefix in allowed_branch_prefixes
	startswith(branch, prefix)
}

scm_branch_restriction := {
	"allowed": false,
	"violations": [sprintf("SCM branch '%v' is not allowed. Only 'main', 'feature/*', and 'release/*' branches are permitted", [input.scm_branch])],
} if {
	input.scm_branch != ""
	not is_allowed_branch(input.scm_branch)
}
