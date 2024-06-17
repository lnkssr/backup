#!/bin/bash

arg1=$1

git pull

git add .

git commit -m $arg1

git push
