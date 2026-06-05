package aap

import rego.v1

default critical_prod_weekend_only := {
	"allowed": true,
	"violations": [],
}

# Check if it's weekend (Saturday or Sunday)
is_weekend if {
	parsed := time.parse_rfc3339_ns(input.created)
	day := time.weekday(parsed)
	day == "Saturday"
}

is_weekend if {
	parsed := time.parse_rfc3339_ns(input.created)
	day := time.weekday(parsed)
	day == "Sunday"
}

critical_prod_weekend_only := {
	"allowed": false,
	"violations": [sprintf("Inventory 'CRITICAL-PROD' can only be used on Saturday and Sunday. Today is a weekday", [])],
} if {
	input.inventory.name == "CRITICAL-PROD"
	not is_weekend
}
