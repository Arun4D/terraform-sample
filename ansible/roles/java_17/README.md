# Ansible

## Execution

````bash
ansible-playbook --inventory inventories/production/hosts production.yml -e "ansible_ssh_user=arun" -Kk
````