#!/bin/bash

repos=(~/Git ~/Clients)

author="jeremy@nancel.net"
period="1 week"

usage() {

cat <<EOF
$(basename $0) : add a sudo user

SYNOPSIS

  $(basename $0) [ -a author ] [ -p period ] [ -d directories ] [ -h ]

    -a author : author to look for

    -p period : period for which to display the commits. 
                Ex. : "1 day" "2 weeks"...

    -d directories : directories in which to check for git repositories
                     Use double quotes if several directories
                     Ex. : "~/Git ~/myrepogit"

    -h : display this help

EOF
}

while getopts "a:p:d::h" opt
do
  case $opt in
    a)
      author=$OPTARG
    ;;
    p)
      period=$OPTARG
    ;;
    d)
      repos=($OPTARG)
    ;;
    h)
      usage
      exit 0
    ;;
    *)
      echo "Unknown option"
      usage
      exit 3
  esac
done

all_repo=$(dirname $(find "${repos[@]}" -type d -name '.git') | grep -v ".terraform/modules")

local_dir=$(echo $PWD)
esc=$(printf '\033')

for i in $(echo $all_repo)
do
  cd $i
  git log --since "$period ago" --author=$author --format='%at %Cgreen%aD%Creset %Cblue%d%Creset %B' | grep -v '^$' | sed -e "s/^/$(tput setaf 1)$(basename $i)$(tput sgr0) /"
done

cd $local_dir
