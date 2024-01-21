#!/bin/bash

function printGreen {
  echo -e "\e[1m\e[32m${1}\e[0m"
}

function logo() {
  bash <(curl -s https://raw.githubusercontent.com/CPITMschool/Scripts/main/logo.sh)
}

function delete() {
  sudo rm -rf $HOME/.eigenlayer
  sudo rm -rf $HOME/eigenlayer
  sudo rm -rf /usr/local/bin/eigenlayer
  sudo systemctl daemon-reload
}

logo
delete

printGreen "Eigenlayer оператор видалено"
