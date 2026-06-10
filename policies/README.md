# Ansible Automation Platform - Policy as Code

This repository contains OPA (Open Policy Agent) policies for enforcing governance and compliance in the Ansible Automation Platform.

## Available Policies

### Master Policy
| Policy Name | AAP Reference Path | Description |
|------------|-------------------|-------------|
| **foxhound_master_policy** | `aap/foxhound_master_policy` | Master policy that aggregates all individual policies and combines their violations. Use this as a single point of enforcement for all policies. |

### Individual Policies

| Policy Name | AAP Reference Path | Description |
|------------|-------------------|-------------|
| **jt_naming_no_slash** | `aap/jt_naming_no_slash` | Prevents job template names from containing forward slashes (/). Enforces naming standards. |
| **no_superuser** | `aap/no_superuser` | Blocks execution of jobs by superuser/platform administrators to prevent privileged account usage. |
| **ee_block_untrusted** | `aap/ee_block_untrusted` | Blocks execution environments from untrusted registries including docker.io, hub.docker.com, localhost, and any registry containing 'suspicious' or 'sus'. |
| **ee_version_enforcement** | `aap/ee_version_enforcement` | Prevents the use of execution environments with the `:latest` tag. Requires specific version tags for reproducibility. |
| **max_forks_limit** | `aap/max_forks_limit` | Enforces a maximum fork count of 100 to prevent resource exhaustion on the automation controller. |
| **scm_branch_restriction** | `aap/scm_branch_restriction` | Restricts job execution to only `main`, `feature/*`, or `release/*` branches. Blocks other branch patterns. |
| **tf_time_restriction** | `aap/tf_time_restriction` | Prevents execution of job templates starting with "TFDemo" or "TFCloud" between 5 PM and 8 AM Eastern time. |
| **critical_prod_weekend_only** | `aap/critical_prod_weekend_only` | Restricts the "CRITICAL-PROD" inventory to weekend use only (Saturday and Sunday). Blocks weekday execution. |
| **github_only_repos** | `aap/github_only_repos` | Enforces that all project repositories must be from github.com. Blocks projects from other SCM providers. |

### Legacy/Example Policies

| Policy Name | AAP Reference Path | Description |
|------------|-------------------|-------------|
| **allowed_false** | `aap/allowed_false` | Simple example policy that always denies execution. Useful for testing policy enforcement. |
| **maintenance_window** | `aap/maintenance_window` | Blocks job execution outside of a defined maintenance window (configurable time range). |

## Usage in Ansible Automation Platform

1. **Configure OPA Server**: Ensure your OPA server is running and accessible to AAP.

2. **Load Policies**: Use the provided Ansible playbook to load policies into OPA:
   ```bash
   ansible-playbook load_policies.yml
   ```

3. **Configure AAP**: In AAP, configure the policy evaluation endpoint for job templates:
   - Navigate to Settings → Jobs → Policy Evaluation
   - Set OPA URL (e.g., `http://localhost:8181/v1/data/aap/foxhound_master_policy`)
   - Enable policy enforcement

4. **Choose Your Enforcement Strategy**:
   - **Master Policy (Recommended)**: Use `aap/foxhound_master_policy` to enforce all policies at once
   - **Individual Policies**: Reference specific policies for targeted enforcement

## Policy Structure

All policies follow this standard structure:

```rego
package aap

import rego.v1

default <policy_name> := {
    "allowed": true,
    "violations": [],
}

<policy_name> := {
    "allowed": false,
    "violations": ["Violation message"],
} if {
    # Conditions that trigger the violation
}
```

## Customization

To customize policies:

1. Edit the `.rego` files in the `policies/` directory
2. Modify thresholds, allowed values, or time windows as needed
3. Reload the policies using the Ansible playbook
4. Test with job template execution in AAP

## Testing Policies

Test policies locally with the OPA CLI:

```bash
# Test a single policy
opa eval -d policies/jt_naming_no_slash.rego -i test_input.json "data.aap.jt_naming_no_slash"

# Test the master policy
opa eval -d policies/ -i test_input.json "data.aap.foxhound_master_policy"
```

## Contributing

When adding new policies:

1. Create a new `.rego` file in the `policies/` directory
2. Follow the standard policy structure
3. Add the policy to `foxhound_master_policy.rego` if it should be part of the master policy
4. Update this README with the new policy details
