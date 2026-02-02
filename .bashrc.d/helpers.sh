#!/bin/bash

mkcd() { mkdir -p -- "$1" && cd "$1"; }
psgrep() { ps aux | grep -v grep | grep -i -- "$@"; }