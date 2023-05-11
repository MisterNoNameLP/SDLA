#!/bin/bash

target="/dat/games/loose/snowrunner/moddedInitialFiles"

mv mods mods.org
cp -r myMods mods

rm -r output/*
cp -r mods/* output
./addDiffs.sh
cp -r output/* $target

rm -r mods
mv mods.org mods