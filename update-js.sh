#!/usr/bin/env bash

/usr/lib/dart/bin/dart2js public/src/bin/main.dart -o public/main.dart.js -c -m
rm public/main.dart.js.*
