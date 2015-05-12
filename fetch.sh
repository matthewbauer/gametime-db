#!/bin/sh

# how to get no-intro files?

for letter in {A..Z}
do
  mkdir -p data/gamerankings/all/$letter
  for i in $(seq 0 100)
  do
    wget "http://www.gamerankings.com/browse.html?numrev=2&sort=2&\
    letter=$letter&page=$i" -O data/gamerankings/all/$letter/$i;
  done
done
