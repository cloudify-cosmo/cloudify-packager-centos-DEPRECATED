#!/bin/bash

REST_CLIENT_SHA=""
COMMON_PLUGIN_SHA=""
MANAGER_SHA=""
PACKMAN_SHA=""

echo bootstrapping...

# update and install prereqs
sudo yum -y update &&
sudo yum install yum-downloadonly wget mlocate yum-utils python-devel libyaml-devel ruby rubygems ruby-devel -y

# install fpm
sudo gem install fpm --no-rdoc --no-ri

# install pip
sudo mkdir /py26 && cd /py26
sudo wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py &&
sudo python get-pip.py &&

# install packman
sudo git clone https://github.com/cloudify-cosmo/packman.git && cd packman
sudo git checkout CFY-1277-adjust-packman-to-work-with-py26 && cd ../
pushd packman
    if [ -n "$PACKMAN_SHA" ]; then
        git reset --hard $PACKMAN_SHA
    fi
    sudo pip install .
popd

# install virtualenv
sudo pip install virtualenv==1.11.4 &&

cd /cloudify-packager/ &&

echo '# create package resources'
sudo pkm get -c centos-agent

echo '# GET PROCESS'
sudo /centos-agent/env/bin/pip install celery==3.0.24
sudo git clone https://github.com/cloudify-cosmo/cloudify-rest-client.git
pushd cloudify-rest-client
    if [ -n "$REST_CLIENT_SHA" ]; then
        git reset --hard $REST_CLIENT_SHA
    fi
    sudo /centos-agent/env/bin/pip install .
popd
sudo git clone https://github.com/cloudify-cosmo/cloudify-plugins-common.git
pushd cloudify-plugins-common
    if [ -n "$COMMON_PLUGIN_SHA" ]; then
        git reset --hard $COMMON_PLUGIN_SHA
    fi
    sudo /centos-agent/env/bin/pip install .
popd
sudo git clone https://github.com/cloudify-cosmo/cloudify-manager.git
pushd cloudify-manager
    if [ -n "$MANAGER_SHA" ]; then
        git reset --hard $MANAGER_SHA
    fi
    pushd plugins/plugin-installer
      sudo /centos-agent/env/bin/pip install .
    popd
popd

# create package
sudo pkm pack -c centos-agent
sudo pkm pack -c cloudify-centos-agent

echo bootstrap done
echo NOTE: currently, using some of packman's features requires that it's run as sudo.
