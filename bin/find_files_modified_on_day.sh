#!/bin/bash

find . -newermt 2018-05-17 ! -newermt 2018-05-18 -ls | egrep -v 'SSSG|vivaldi|\.cache|\.local|\.terraform|\.git|\.config|\.Idea'
