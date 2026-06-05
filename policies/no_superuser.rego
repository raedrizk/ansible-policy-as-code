package aap

import rego.v1

default no_superuser := {
	"allowed": true,
	"violations": [],
}

no_superuser := {
	"allowed": false,
	"violations": ["System/Platform Administrator is not allow to launch jobs"],
} if {
	input.created_by.is_superuser
}
