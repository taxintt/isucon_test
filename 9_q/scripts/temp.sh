#!/bin/bash

# https://qiita.com/magicant/items/f3554274ee500bddaca8
set -Ceu

cd $HOME/src/github.com/isucon/isucon9-qualify

# remove binary file
rm -rf ./bin/*

# source code
LOAD_MASTER_COMMAND=`git checkout master && 
                 git pull origin master`
# LOAD_COMMAND=`git checkout master && 
#                  git pull origin master && 
#                  git fetch origin ${TARGET} && 
#                  git checkout ${TARGET} && 
#                  git pull origin ${TARGET} && 
#                  git merge master`

## pull latest data
NGINX_COMMAND=`hostname && 
                ${LOAD_MASTER_COMMAND}` 

# nginx
## check configuration file
sudo /usr/sbin/nginx -t

## reload nginx
sudo service nginx reload