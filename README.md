# sunflower-timelapse

### Introduction ###
My son planted a sunflower seed at school and had to bring it home to look after it and watch it grow. I thought it would be good to use timelapse-photography as a way to capture the slow progress and play it back later.

### Set up the camera ###
I have a Raspberry Pi Camera board v1. The following script seems to yield decent results:
```bash
#!/bin/bash
DATE=$(date +"%Y%m%d_%H%M%S")

raspistill -q 97 -vf -hf -ex night -a 12 -o sun$DATE.jpg -v
raspistill -q 97 -vf -hf -ex night -a 12 -o matrix_drc/sun${DATE}.jpg -v --awb flash --metering matrix --drc med
```
* The script will create pictures named using date and time. This makes it easy to work with the files if you are looking for an images taken at any one moment. However, to create a video the files will need to be renamed later.
* ```-q 97```: JPEG quality is 97.
* ```-vf -hf```: Flip both the vertical and horizontal axis. Depends on how you mount your sensor.
* ```-ex night```: Use night exposure. This seems to work well for daylight too, but allows the camera to choose longer exposures when the light is low.
* ```--awb flash```: I decided to avoid the auto white baolance setting to make sure I get a persistent white balance across. frames. I choose the flash white balance setting setting since it yielded the best result where I was taking pictures.
* ```--metering matrix```: Not actually sure if this performs better than 'average', but this is what I used anyway.
* ```--drc med```: The dynamic range setting of medium yielded some extra detail in darker areas of the image. 


### Copy the images to NAS ###
```bash
rsync -vvz -t -e ssh /home/pi/*.jpg fanus@sakkie.local:/media/data/fotos/sunflower/
```
* Will use SSH and will prompt for password
* Add ```-n``` to do a dry-run and test the command


### Cropping ###
Input images are 2592x1944, but target frame is 1920x1080, andno resizing is needed. Only cropping.
* Calculate X offset
	* Image width = 2592
	* Target width = 1920
	* X-offset = (2592 - 1920) / 2 = 336
* Calculate Y offset
  * Image height = 1944
  * Target width = 1080
  * Y offset = (1944 - 1080) / 2 = 432

Now use ```convert``` [Imagemagick](http://www.imagemagick.org/script/convert.php) to crop the images
```bash
convert "$x" -crop 1920x1080+336+432 "$y";
```

### White balance ###
Found a really useful script written by [Fred Weinhaus](http://www.fmwconcepts.com/imagemagick/autowhite/index.php) called 'autowhite'. It managed to balance all images to an acceptable level without any further processing needed.
```bash
autowhite input.jpg output.png
```
I choose to output in PNG format to avoid further image qaulity loss.

### Deflicker ###
Images may hav different exposures, so you will need to 'deflicker' them, or adjust exposure and possibly white balance.
Try this:
* Original script: https://ubuntuforums.org/showthread.php?t=2022316
* Another source for above https://github.com/rambo/timelapse/blob/master/timelapse-deflicker.pl

* Different approach: http://im.snibgo.com/gainbias.htm


```bash
sudo apt-get install libfile-type-perl libterm-progressbar-perl
git clone https://github.com/cyberang3l/timelapse-deflicker/blob/master/timelapse-deflicker.pl
cd timelapse-deflicker
./timelapse-deflicker -h
```


### Rename Images ###
Rename a folder full of images (in this case they are named according to date and time) to a numbered list:
```
ls sun20160808*.jpg| awk 'BEGIN{ a=0 }{ printf "mv %s img%06d.JPG\n", $0, a++ }' | bash
```
Or, you could just symlink them:
```
ls ~/matrix_drc/sun20160810*.jpg| awk 'BEGIN{ a=0 }{ printf "ln -s %s img%06d.JPG\n", $0, a++ }' | bash
```
If you wish to return to the original naming convention, these commands may help:
```bash
exiv2 rename -vtF -r "sun%Y%m%d_%H%M%S" *.JPG
find . -name '*.JPG' -exec rename 's/\.JPG/\.jpg/' '{}' \;
```


---

### Video ###
Encode the numbered images to an MP4, 15fps, Q=22
```
avconv -y -r 15 -i img%06d.JPG -r 15 -vcodec libx264 -crf 22.0 -vf crop=1920:1080,scale=iw:ih,unsharp,hqdn3d fullhd_unsharp2.mp4
```
* Will crop the input images to 1080p. Not sure what will happen if inout is smaller.
* I find the unsharp filter helps with the soft images out of the RPi camera v1
* The hqdn3 filter reduces some noise, which in turn reduces file size,  but still preserves edges.


---
### References ###
Click [here](http://techedemic.com/2014/09/18/creating-a-timelapse-clip-with-avconv/) for the orignal post.
General timelapse info at [www.learntimelapse.com](http://www.learntimelapse.com/time-lapse-exposure-avoiding-flicker-and-dragging-shutter/)
