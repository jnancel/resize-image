#!/bin/bash

rsync -avp --exclude-from=/home/jeremy/rsync_exclude_files /home/jeremy/* silver-ext:/var/services/homes/jeremy/CloudStation/Taf/Claranet/
