#!/bin/bash

check_command_available() {
  which ${1} &> /dev/null
  test $? -eq 0
}

check_and_install() {
  echo "Checking if ${1} is installed"
  check_command_available ${1}

  if [ $? -eq 0 ]
  then
    echo "${1} installed"
  else
    echo "${1} not installed, proceeding with installation"
    dnf install ${1} -y
  fi
}

check_and_install "ruby"
check_and_install "git"

BASEPATH=$(dirname ${0})

ruby ${BASEPATH}/src/index.rb
