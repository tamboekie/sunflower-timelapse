#!/bin/bash

DATE=$(date +"%Y%m%d_%H%M%S")

raspistill -q 97 -vf -hf -ex night -a 12 -o sun$DATE.jpg -v
#raspistill -q 97 -vf -hf -ex night -a 12 -o matrix_drc/A${DATE}_cloud.jpg -v --awb cloud --metering matrix --drc med
#raspistill -q 97 -vf -hf -ex night -a 12 -o matrix_drc/A${DATE}_shade.jpg -v --awb shade --metering matrix --drc med
#raspistill -q 97 -vf -hf -ex night -a 12 -o matrix_drc/A${DATE}_flo.jpg -v --awb fluorescent --metering matrix --drc med
#raspistill -q 97 -vf -hf -ex night -a 12 -o drc_low/sun${DATE}.jpg -v --drc low
#raspistill -q 97 -vf -hf -ex night -a 12 -o drc_med/sun${DATE}.jpg -v --drc med


