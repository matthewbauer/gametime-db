#!/bin/sh

find data -name '*.dat' -print0 | xargs -0 lua dat_converter.lua > db.json

node vgdb.js
