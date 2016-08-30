# sunflower-timelapse

## Introduction ##
These files are part of the ```sunflower-timelapse``` project. Full details are available at https://tamboekie.github.io/sunflower-timelapse/.

## sunflowercam.sh ##
This script should be copied to your Raspberry Pi. Add a cron job to call it regurlarly - say once very 5 minutes.
* Uses ```raspistill``` which is standard on Raspbian Wheezy / Jesse
* Tested on Raspbian Jesse with a Raspberry Pi 3 and camera module v1

## mklapse.sh ##
This script is used to transfer the images captured by the Raspberry Pi camera to a time-lapse video. It tries to compensate for exposure between images, as well as variantions in white balance.
* Dependancies
  * ```autowhite``` script by [Fred Weinhaus](http://www.fmwconcepts.com/imagemagick/autowhite/index.php)
  * ```imagemagick``` package from the repo
  * ```timelapse-deflicker``` script from https://github.com/cyberang3l/timelapse-deflicker
  * ```ffmpeg``` and ```libavcodec-extra``` packages from the repo
* Options
  * ```-r|--rate <number>``` will set the output video frame rate to \<number\>. The default is 60
  * ```-o|--outfile <filename>``` sets the output video to \<filename\>. The default is timelapse.mp4
* Tested on Ubuntu 16.04
