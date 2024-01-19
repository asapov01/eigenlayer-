#!/bin/bash

function printGreen {
  echo -e "\e[1m\e[32m${1}\e[0m"
}

function install() {
    clear
    source <(curl -s https://raw.githubusercontent.com/CPITMschool/Scripts/main/logo.sh)
    printGreen "Встановлення необхідних залежностей"
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt install -y curl git jq lz4 build-essential unzip && apt install lz4
    sudo apt install docker.io -y
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  
    bash <(curl -s "https://raw.githubusercontent.com/nodejumper-org/cosmos-scripts/master/utils/go_install.sh")
    source .bash_profile
  
    printGreen "Встановлення EigenLayer"
    git clone https://github.com/NethermindEth/eigenlayer.git
    cd eigenlayer
    mkdir -p build
    go build -o build/eigenlayer cmd/eigenlayer/main.go
    cp ./build/eigenlayer /usr/local/bin/
    printGreen "Зараз по черзі створяться ключі ECDSA та BLS, після створення кожного обов'язково збережіть інформацію наприклад в блокнот"
    printGreen "Також потрібно буде створити пароль в форматі(наприклад): Dima123!"
    eigenlayer operator keys create --key-type ecdsa mykeyecdsa
    echo ""
    printGreen "Збережіть інформацію вище про ваш ключ ECDSA, наприклад собі в блокнот"
    read -p "Ви зберегли та готові продовжити встановлення? [Y/N] " answer
    if [ "$answer" != "Y" ] && [ "$answer" != "y" ]; then
        printGreen "Встановлення відмінено"
        exit 0
    fi

    eigenlayer operator keys create --key-type bls myblskey
    echo ""
    printGreen "Збережіть інформацію вище про ваш BLS KEY, наприклад собі в блокнот"
    read -p "Ви зберегли та готові продовжити встановлення? [Y/N] " answer
    if [ "$answer" != "Y" ] && [ "$answer" != "y" ]; then
        printGreen "Встановлення відмінено"
        exit 0
    fi

    echo ""
    printGreen "Тепер необхідно імпортувати закритий ключ ECDSA в Metamask, та слідкувати інструкції з гайду"
    touch /root/eigenlayer/cli/operator/config/operator-config.yaml
    source $HOME/.bash_profile
}

install
