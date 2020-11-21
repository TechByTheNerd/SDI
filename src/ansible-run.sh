#!/bin/bash

if [[ $# < 2 ]]; then
  cat <<HELP
Wrapper script for ansible-playbook to apply single role.

Usage: $0 <host-pattern> <role-name> [ansible-playbook options]

Examples:
  $0 dest_host my_role
  $0 custom_host my_role -i 'custom_host,' -vv --check
HELP
  exit
fi

HOST_PATTERN=$1
shift
ROLE=$1
shift

echo "Trying to apply role \"$ROLE\" to host/group \"$HOST_PATTERN\"..."

export ANSIBLE_ROLES_PATH="$(pwd)/roles"
export ANSIBLE_RETRY_FILES_ENABLED="False"
export USER_PASSWORD="`date +%s | sha256sum | base64 | head -c 32 ; echo`"
export ENCRYPTED_PASSWORD="`echo $USER_PASSWORD | mkpasswd --method=sha-512 -s`"

echo **NOTE** User password is: $USER_PASSWORD

ANSIBLE_DEBUG=false ANSIBLE_VERBOSITY=1 ansible-playbook -i ./inventory.yaml "$@" /dev/stdin <<END
---
- hosts: $HOST_PATTERN
  gather_facts: false
  remote_user: root
  vars:
    password: "{{ lookup('env','ENCRYPTED_PASSWORD') }}"
  roles:
    - $ROLE
END