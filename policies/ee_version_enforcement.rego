package aap

import rego.v1

default ee_version_enforcement := {
	"allowed": true,
	"violations": [],
}

# Extract version tag from image
get_image_tag(image) := tag if {
	parts := split(image, "/")
	image_with_tag := parts[count(parts) - 1]
	tag_parts := split(image_with_tag, ":")
	count(tag_parts) == 2
	tag := tag_parts[1]
} else := "" if {
	true
}

ee_version_enforcement := {
	"allowed": false,
	"violations": [sprintf("Execution environment '%v' cannot use the ':latest' tag. Please specify a specific version", [input.execution_environment.image])],
} if {
	input.execution_environment.image
	tag := get_image_tag(input.execution_environment.image)
	tag == "latest"
}
