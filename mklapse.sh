#!/bin/bash

# Globals settings
input=`pwd`
output=${input}/crop
video=timelapse.mp4

mkdir -p ${output}

#
# Process all JPG files in THIS folder
#
shopt -s nullglob
for x in *.jpg;
do
  echo Process "$x"
  # Set destination file
  y="$output"/"$x";
  # First crop to lossless PNG
  convert "$x" -crop 1920x1080+336+432 "$y".png;
  # Now auto-white balance the PNG to JPEG
  autowhite "$y".png "$y"
done


# Remove temporary PNG files
cd ${output}
rm *.png

# Now remove flicker between frames
timelapse-deflicker.pl

# Finally rename files and make a video
cd Deflickered
ls *.jpg| awk 'BEGIN{ a=0 }{ printf "mv %s img%06d.JPG\n", $0, a++ }' | bash
avconv -y -r 30 -i img%06d.JPG -r 30 -vcodec libx264 -crf 22.0 -vf crop=1920:1080,scale=iw:ih,unsharp,hqdn3d ${video}

exit 0
