package aap

import rego.v1

default foxhound_master_policy := {
    "allowed": true,
    "violations": [],
}

# Aggregate all policy violations
all_violations contains violation if {
    some violation in data.aap.jt_naming_no_slash.violations
}

all_violations contains violation if {
    some violation in data.aap.no_superuser.violations
}

all_violations contains violation if {
    some violation in data.aap.ee_block_untrusted.violations
}

all_violations contains violation if {
    some violation in data.aap.ee_version_enforcement.violations
}

all_violations contains violation if {
    some violation in data.aap.max_forks_limit.violations
}

all_violations contains violation if {
    some violation in data.aap.scm_branch_restriction.violations
}

all_violations contains violation if {
    some violation in data.aap.tf_time_restriction.violations
}

all_violations contains violation if {
    some violation in data.aap.critical_prod_weekend_only.violations
}

all_violations contains violation if {
    some violation in data.aap.github_only_repos.violations
}

# Deny if any policy fails
foxhound_master_policy := {
    "allowed": false,
    "violations": all_violations,
} if {
    count(all_violations) > 0
}
