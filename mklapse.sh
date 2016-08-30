#!/bin/bash

# Copyright (c) 2016 tamboekie
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

echo " "
echo "mklapse, v0.1"
echo "----------------------------------------------"

# Globals settings
RATE=60
input=`pwd`
output=${input}/crop
OUTFILE=out_mklapse.mp4

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -r|--rate)
    RATE="$2"
    shift # past argument
    ;;
    -o|--outfile)
    OUTFILE="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done
echo "Frame Rate        = ${RATE}"
echo "Output video file = ${OUTFILE}"
echo "----------------------------------------------"


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
ffmpeg -y -r "${RATE}" -i img%06d.JPG -r "${RATE}" -vcodec libx264 -preset slow -crf 18.0 -vf crop=1920:1080,scale=iw:ih,unsharp,hqdn3d "${OUTFILE}"

exit 0
