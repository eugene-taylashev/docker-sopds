#!/usr/bin/env bash
#-------------------------------------------------------------------------------
#  Sample script to run the Simple OPDS image with params
#-------------------------------------------------------------------------------

#-- Main settings
IMG_NAME=sopds           #-- container/image name
VERBOSE=1                #-- 1 - be verbose flag
SVER="20211117"
#-- Check architecture
ARCH=""
[[ $(uname -m) =~ ^armv7 ]] && ARCH="armv7-"


source functions.sh #-- Use common functions

stop_container   $IMG_NAME
remove_container $IMG_NAME

docker run -d \
  --name $IMG_NAME \
  -p 8001:8001 \
  -e VERBOSE=${VERBOSE} \
  etaylashev/sopds:${ARCH}latest

exit 0


