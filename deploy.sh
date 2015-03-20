#!/bin/bash
set -e
: ${ENV?"Need to set ENV"}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ansible-playbook -i $DIR/server-inventories/$ENV $DIR/playbook-setup.yml
echo "Deploying app..."
cd ../app
echo $DIR/server-inventories/_vagrant
ansible-playbook -i $DIR/server-inventories/$ENV $DIR/playbook-build-app.yml --connection=local
cd ../deploy
ansible-playbook -i $DIR/server-inventories/$ENV -M ./library $DIR/playbook-app-only.yml

# wait
echo 'Deploy finished running on vagrant.'