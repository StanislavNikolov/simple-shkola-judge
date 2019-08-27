#!/bin/bash

user="$1"
prob="$2"

bin=solutions/"$user"/"$prob"
g++ -std=c++11 solutions/"$user"/"$prob".cpp -O2 -o "$bin"

mkdir -p results/"$user"/
./checker.sh tests/"$prob" "$bin" 0.2 > results/"$user"/"$prob".txt
