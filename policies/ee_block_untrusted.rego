package aap

import rego.v1

default ee_block_untrusted := {
	"allowed": true,
	"violations": [],
}

# Define blocked/untrusted registries
untrusted_registries := [
	"docker.io",
	"hub.docker.com",
	"localhost",
	"127.0.0.1",
]

# Extract registry from EE image
get_registry(image) := registry if {
	parts := split(image, "/")
	count(parts) > 1
	registry := parts[0]
} else := "docker.io" if {
	# Images without registry prefix default to docker.io
	true
}

# Check if registry is untrusted
is_untrusted_registry(image) if {
	registry := get_registry(image)
	some untrusted in untrusted_registries
	contains(registry, untrusted)
}

# Check if registry contains suspicious keywords
is_untrusted_registry(image) if {
	registry := get_registry(image)
	contains(lower(registry), "suspicious")
}

is_untrusted_registry(image) if {
	registry := get_registry(image)
	contains(lower(registry), "sus")
}

ee_block_untrusted := {
	"allowed": false,
	"violations": ["Execution environment is from an untrusted registry. Blocked registries: docker.io, hub.docker.com, localhost, or contains 'suspicious'/'sus'"],
} if {
	input.execution_environment.image
	is_untrusted_registry(input.execution_environment.image)
}
