package aap

import rego.v1

default tf_time_restriction := {
	"allowed": true,
	"violations": [],
}

# Define restricted time window in UTC (5 PM - 8 AM EST = 22:00 - 13:00 UTC)
# Using EST (UTC-5) for consistency
restricted_start_hour := 22  # 5 PM EST = 22:00 UTC
restricted_end_hour := 13     # 8 AM EST = 13:00 UTC

# Extract the job creation timestamp hour (in UTC)
created_clock := time.clock(time.parse_rfc3339_ns(input.created))
created_hour_utc := created_clock[0]

# Check if current time is in restricted window (5 PM to 8 AM spans midnight)
is_restricted_time if {
	created_hour_utc >= restricted_start_hour  # After 5 PM EST (22:00 UTC)
}

is_restricted_time if {
	created_hour_utc < restricted_end_hour  # Before 8 AM EST (13:00 UTC)
}

# Check if job template name starts with TFDemo or TFCloud
is_tf_job_template if {
	startswith(input.job_template.name, "TFDemo")
}

is_tf_job_template if {
	startswith(input.job_template.name, "TFCloud")
}

tf_time_restriction := {
	"allowed": false,
	"violations": [sprintf("Job template '%v' cannot be executed between 5 PM and 8 AM Eastern time. Current time: %02d:%02d UTC", [input.job_template.name, created_hour_utc, created_clock[1]])],
} if {
	is_tf_job_template
	is_restricted_time
}
