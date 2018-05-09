#!/bin/bash

version=$1

if [ "x$version" == "x" ]
then
  echo "No version specified. Exiting..."
  exit 1
fi

ln -sf /home/jeremy/Terraform/$version/terraform /home/jeremy/bin/
