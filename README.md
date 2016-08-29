# sunflower-timelapse

## Introduction ##
These files are part of the ```sunflower-timelapse``` project. Full details are available at https://tamboekie.github.io/sunflower-timelapse/.

## sunflowercam.sh ##
This script should be copied to your Raspberry Pi. Add a cron job to call it regurlarly - say once very 5 minutes.

## mklapse.sh ##
This script is used to transfer the images captured by the Raspberry Pi camera to a time-lapse video. It tries to compensate for exposure between images, as well as variantions in white balance.
