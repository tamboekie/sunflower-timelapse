# sunflower-timelapse

## Introduction ##
These files are part of the ```sunflower-timelapse``` project. Full details are available at https://tamboekie.github.io/sunflower-timelapse/.

## sunflowercam.sh ##
This is a simple script to take images using a Raspberry Pi camera module. It should be copied to your Raspberry Pi and then add a cron job to call it regurlarly - say once very 5 minutes.
* Uses `raspistill` which is standard on Raspbian Wheezy / Jesse
* Tested on Raspbian Jesse with a Raspberry Pi 3 and camera module v1 (Any RPi should work).

## mklapse.sh ##
This script is used to encode the images captured by the Raspberry Pi camera into a time-lapse video. It tries to compensate for exposure between images, as well as variations in white balance. You should run it in the folder where your JPEG images are stored. The file extenstions must be `*.jpg` and case is important.
* Dependancies
  * ```autowhite``` script by [Fred Weinhaus](http://www.fmwconcepts.com/imagemagick/autowhite/index.php). This script is Copyright © Fred Weinhaus and is used with permission
  * ```timelapse-deflicker``` script from https://github.com/cyberang3l/timelapse-deflicker
  * ```ffmpeg``` and ```imagemagick``` packages from the repo
* Options
  * `-r|--rate <number>` will set the output video frame rate to \<number\>. The default is `60`
  * `-o|--outfile <filename>` sets the output video to \<filename\>. The default is `out_mklapse.mp4`
  * `-f|--filter <hqdn3d settings>` Pass the settings directly to the hqdn3d filter. The default is `2:2:15:25`
* Tested on Ubuntu 16.04
