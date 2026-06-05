package aap

import rego.v1

default jt_naming_no_slash := {
    "allowed": true,
    "violations": [],
}

# Validate that job template name does not have a slash
jt_naming_no_slash := result if {
    # Extract values from input
    org_name := object.get(input, ["organization", "name"], "")
    project_name := object.get(input, ["project", "name"], "")
    jt_name := object.get(input, ["job_template", "name"], "")

    print("org_name:", org_name)
    print("project_name:", project_name)
    print("jt_name:", jt_name)
    print("input", input)


    # Check if job template name contains slash
    contains(jt_name, "/")

    result := {
        "allowed": false,
        "violations": [sprintf("Job template naming for '%v' does not comply with standards and contains a slash", [jt_name])]
    }
}