# Worldline SRE Exercise - MySQL Deployment

## Objectif

Déployer une mini-plateforme avec un service MySQL 8.4.x Community sur Rocky Linux, avec une configuration système précise, versionnée sur Git et automatisée par Ansible. Bonus : déploiement sur Azure via Terraform.

## Architecture

- OS : Rocky Linux 10.1 (local) / Rocky Linux 9.6 (Azure)
- Base de données : MySQL 8.4.9 Community Server
- Logs MySQL : Partition dédiée XFS montée sur /var/log/mysql
- Paramètre système : vm.swappiness=1
- Automatisation : Ansible (playbooks idempotents)
- Provisionnement cloud : Terraform (Azure)

## Structure du projet

- README.md
- ansible/inventory/hosts.ini
- ansible/files/my.cnf
- ansible/playbook-system.yml (Config système + MySQL)
- ansible/playbook-database.yml (Création BDD + utilisateur)
- terraform/main.tf (Provisionnement Azure)

## Utilisation

### Local (VMware)
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook-system.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook-database.yml

### Azure (Terraform + Ansible)
cd terraform && terraform init && terraform apply
ssh msekkouri@PUBLIC_IP
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook-system.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook-database.yml

## Auteur

Mouaad Sekkouri - Exercice technique Worldline SRE
