#!/bin/bash

# Ce script se base sur les instructions fournies par Docker: https://docs.docker.com/engine/security/protect-access/

# Creation d un dossier cache docker dans lequels les cles seront stockees
mkdir -pv ~/.docker
cd .docker/

echo Entre l adresse ip de ton serveur
read server_ip

# SERVER
# Generation de la cle prive du CA
openssl genrsa -aes256 -out ca-key.pem 4096

# Generation de la cle publique du CA
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem

# Generation de la cle prive du serveur
openssl genrsa -out server-key.pem 4096

# Generation du Certificate Signing Request (CSR) server
openssl req -subj "/CN=$server_ip" -sha256 -new -key server-key.pem -out server.csr

# Creation d un fichiers pour permettre d autres IP 127.0.0.1
echo subjectAltName = IP:$server_ip,IP:127.0.0.1 >> extfile.cnf

# Definir l utilisation des cles pour l authentification serveur
echo extendedKeyUsage = serverAuth >> extfile.cnf

# Generation du certificat signe par le CA
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out server-cert.pem -extfile extfile.cnf

# CLIENT (applicable aussi sur le serveur si les 2 parties sont sur la meme machine)
# Generation d'un cle prive client
openssl genrsa -out key.pem 4096

# Generation du CSR client
openssl req -subj '/CN=client' -new -key key.pem -out client.csr

# Definir les cles pour l'authentification client
echo extendedKeyUsage = clientAuth > extfile-client.cnf

# Generation des certificats signes
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out cert.pem -extfile extfile-client.cnf

# Definir l hote Docker et la verification TLS
export DOCKER_HOST=tcp://$server_ip:2376 DOCKER_TLS_VERIFY=1
