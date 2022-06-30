#!/bin/bash

##
## 1. Installs docker on all cloudlab machines in the manifest
## 2. Initializes a docker swarm in all of them
## 3. Installs docker-hadoop on the manager
##
## Invoke this script like this:
## `./prepare-cloudlab-nodes.sh manifest.xml cloudlab_username ~/.ssh/rsa_key_for_cloulab`
##
## where:
##  the first argument `manifest.xml` is a file that contains the manifest downloaded from Cloudlab
##  the second argument is the cloudlab username
##  the third argument is the cloudlab key optionally (if you pass that manually to ssh)

manifest=${1?"ERROR: No cloudlab manifest file given"}
user=${2?"ERROR: No cloudlab user given"}

## Optionally the caller can give us a private key for the ssh
key=$3
if [ -z "$key" ]; then
    key_flag=""
else
    key_flag="-i ${key}"
fi

grep "hostname=" "${manifest}" | sed -E 's/^.*hostname="([a-z0-9\.]+)".*$/\1/g' | sort -u > hostnames.txt

echo "Hosts:"
cat hostnames.txt

##
## Install docker on all nodes
##
while IFS= read -r hostname
do
  echo "Installing on ${user}@${hostname}..." 
  ## Notes:
  ## The following line was added to not have the interactive check
  ##   `-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no`
  ##
  ## This could be made more robust to also work if a connection fails,
  ##   maybe using `nohup` on the remote server or something.
  ssh ${key_flag} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 22 ${user}@${hostname} 'bash -s' <<'ENDSSH'
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
ENDSSH
done < hostnames.txt

##
## Initialize a swarm from the manager
##
manager_hostname=$(head -n 1 hostnames.txt)
echo "Manager is: $manager_hostname"
{
ssh ${key_flag} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 22 ${user}@${manager_hostname} 'bash -s' <<'ENDSSH'
sudo docker swarm init --advertise-addr $(hostname -i)
# sudo docker swarm join-token worker
ENDSSH
} | tee swarm_advertise_output.txt

tail +2 hostnames.txt > worker_hostnames.txt


cat swarm_advertise_output.txt | grep "docker swarm join --token" | sed 's/^/sudo/g' > join_swarm_command.sh

##
## Join swarm with workers
##
while IFS= read -r hostname
do
  echo "Joining swarm from ${user}@${hostname}..." 
  ## Notes:
  ## The following line was added to not have the interactive check
  ##   `-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no`
  ##
  ## This could be made more robust to also work if a connection fails,
  ##   maybe using `nohup` on the remote server or something.
  ssh ${key_flag} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 22 ${user}@${hostname} 'bash -s' < join_swarm_command.sh
done < worker_hostnames.txt

##
## Install our Hadoop infrastructure
##
ssh ${key_flag} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 22 ${user}@${manager_hostname} 'bash -s' <<'ENDSSH'
## Just checking that the workers have joined
sudo docker node ls
git clone https://github.com/binpash/docker-hadoop.git
cd docker-hadoop

## TODO: Need to do some changes in compose

## Execute the setup with `nohup` so that it doesn't fail if the ssh connection fails
nohup sudo ./setup-swarm.sh
ENDSSH