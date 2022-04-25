#!/bin/dash

size=${2:-500}
pdf-crop-margins -o "$1.large.pdf" -p 100 -a4 "-$size" 0 "-$size" 0 "$1"