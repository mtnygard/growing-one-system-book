#! /bin/bash

FILE=$1
REV=${2:-HEAD}
START=${3:-"1"}
END=${4:-'$'}

cd ../growing-one-system
git show ${REV}:${FILE} | sed -n "${START},${END}p"
