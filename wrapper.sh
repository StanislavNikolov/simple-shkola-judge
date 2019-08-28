#!/bin/bash

user="$1"
prob="$2"

bin=solutions/"$user"/"$prob"
mkdir -p results/"$user"/
if g++ -std=c++11 solutions/"$user"/"$prob".cpp -O2 -o "$bin"; then
	./fchecker.sh "$prob" "$bin" 0.2 > results/"$user"/"$prob".html
else
	echo "Failed to compile" > results/"$user"/"$prob".html
fi
