package aap

import rego.v1

default max_forks_limit := {
	"allowed": true,
	"violations": [],
}

# Define maximum allowed forks to prevent resource exhaustion
max_forks := 100

max_forks_limit := {
	"allowed": false,
	"violations": [sprintf("Fork count of %v exceeds maximum allowed limit of %v. This prevents resource exhaustion", [input.forks, max_forks])],
} if {
	input.forks > max_forks
}
