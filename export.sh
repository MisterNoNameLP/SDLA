#!/bin/bash

target="/dat/games/loose/snowrunner/moddedInitialFiles"

rm -r output/*
cp -r mods/* output
./addDiffs.sh
cp -r output/* $target