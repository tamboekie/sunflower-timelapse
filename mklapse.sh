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

echo ""
echo "mklapse.sh, v0.1"
echo "----------------------------------------------"

# Globals settings
RATE=60
INDIR=`pwd`
TMPDIR=$(mktemp --tmpdir=${INDIR} -dt "$(basename $0).XXXXXXXXXX")
OUTFILE=out_mklapse.mp4

# command-line parsing
while [[ $# -gt 0 ]]
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
    -h|--help)
        echo " -r|--rate <framerate>    Set frame rate. Default ${RATE}"
        echo " -o|--outfile <filename>  Set output video filename. Default ${OUTFILE}"
        echo " -h|--help                Print this help text"
        echo ""
        exit 0
        ;;
    *)
        # unknown option
        echo "Error: Unknown option"
        exit 1
        ;;
esac
shift # past argument or value
done

# display options
echo "Frame Rate        = ${RATE}"
echo "Output video file = ${OUTFILE}"
echo "$TMPDIR"
echo "----------------------------------------------"

# create output directory
mkdir -p "$TMPDIR"

# Process all *.jpg files in THIS folder
shopt -s nullglob
for x in *.jpg;
do
  echo "Process $x"
  # Set destination file
  y="$TMPDIR"/"$x";
  # First crop to lossless PNG
  convert "$x" -crop 1920x1080+336+432 "$y".png;
  # Now auto-white balance the PNG to JPEG
  autowhite "$y".png "$y"
  rm "$y".png
done

# Remove flicker between frames
cd "$TMPDIR"
timelapse-deflicker.pl

# Finally rename files and make a video
cd Deflickered
ls *.jpg| awk 'BEGIN{ a=0 }{ printf "mv %s img%06d.JPG\n", $0, a++ }' | bash
ffmpeg -y -r "$RATE" -i img%06d.JPG -r "$RATE" -vcodec libx264 -preset slow -crf 18.0 -vf crop=1920:1080,scale=iw:ih,unsharp,hqdn3d "$OUTFILE"

# move video from TMPDIR to INDIR
mv "$OUTFILE" "$INDIR"
cd "$INDIR"

exit 0
