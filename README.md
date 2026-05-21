# Worldline SRE Exercise - MySQL Deployment

## Objectif

Deployer une mini-plateforme avec un service MySQL 8.4.x Community sur Rocky Linux, avec une configuration systeme precise, versionnee sur Git et automatisee par Ansible.

## Architecture

- OS : Rocky Linux 10.1 (Red Quartz)
- Base de donnees : MySQL 8.4.9 Community Server
- Logs MySQL : Partition dediee /dev/sda1 montee sur /var/log/mysql (10 Go, XFS)
- Parametre systeme : vm.swappiness=1
- Automatisation : Ansible (playbooks idempotents)

## Structure du projet

- README.md
- ansible/inventory/hosts.ini
- ansible/files/my.cnf
- ansible/playbook-system.yml (Playbook 1 : Config systeme + MySQL)
- ansible/playbook-database.yml (Playbook 2 : Creation BDD + utilisateur)

## Playbooks Ansible

### Playbook 1 - Configuration systeme et MySQL (playbook-system.yml)

- Configure vm.swappiness=1 (persistant)
- Formate et monte la partition dediee pour les logs MySQL (/dev/sda1 vers /var/log/mysql)
- Installe MySQL 8.4.x Community depuis le depot officiel
- Deploie la configuration MySQL avec les logs pointant vers la partition dediee
- Active et demarre le service mysqld via systemd

### Playbook 2 - Base de donnees et utilisateur (playbook-database.yml)

- Cree la base de donnees worldline_db
- Cree l utilisateur wl_user avec les privileges sur worldline_db
- Verifie l acces a la base de donnees

## Utilisation

ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook-system.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook-database.yml

## Auteur

Mouaad Sekkouri - Exercice technique Worldline SRE
