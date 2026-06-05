dnf install podman ansible-core

podman run -it --rm -p 8181:8181 openpolicyagent/opa run --server --addr :8181

ansible-playbook opa_load_policies.yml