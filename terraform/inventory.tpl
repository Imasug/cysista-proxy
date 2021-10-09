---
cysista-proxy:
  hosts:
    ${ip}
  vars:
    ansible_ssh_user: ${user}
    ansible_ssh_private_key_file: ${key_file}
