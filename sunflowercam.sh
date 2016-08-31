#!/bin/bash
DATE=$(date +"%Y%m%d_%H%M%S")

raspistill -q 97 -vf -hf -ex night -a 12 -o sun$DATE.jpg -v
