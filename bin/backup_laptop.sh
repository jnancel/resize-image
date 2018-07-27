#!/bin/bash

rsync -avp --delete --exclude-from=/home/jeremy/Perso/rsync_exclude_files /home/jeremy/* silver-ext:/var/services/homes/jeremy/CloudStation/Taf/Claranet/
