#!/bin/sh
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git pull origin master
#git submodule foreach git submodule update

