#!/bin/bash

# https://qiita.com/magicant/items/f3554274ee500bddaca8
set -Ceu

# run main service
run_main_service() {
    cd $HOME/src/github.com/isucon/isucon9-qualify
    cd webapp/go
    $(GO111MODULE=on go run api.go main.go) 
}

# create binary file
create_binary_files() {
    cd ../..
    make    
}

# run other services
run_payment_services() {
    ./bin/payment 
    echo $!
}

run_shipment_services() {
    ./bin/shipment
    echo $!
}

function main() {
    run_main_service
    create_binary_files

    payment_pid=`run_payment_services`
    shipment_pid=`run_shipment_services`

    # https://dev.classmethod.jp/articles/waiting-for-your-input-with-read-command/
    read -p "Hit enter for exiting services: "
    kill -TERM ${payment_pid} 
    kill -TERM ${shipment_pid} 
}

main