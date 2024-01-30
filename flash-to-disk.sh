#!/usr/bin/env bash

usage ()
{
    echo "Usage: $0 --src (e.g tmp/deploy/images/raspberrypi3/core-image-minimal-raspberrypi3.wic.bz2) --dst (e.g. /dev/sdb)"
}

die ()
{
    echo "$1"
    exit 1
}

while [ $# -gt 0 ]; do
    case "$1" in
        --src)
            SRC=$2
            shift 2
            ;;
        --dst)
            DST=$2
            shift 2
            ;;
        *)
            usage
            die "Unknown argument: $1"
            ;;
    esac
done

if [ -z "$SRC" ]; then
    usage
    die "Missing --src argument"
fi

if [ -z "$DST" ]; then
    usage
    die "Missing --dst argument"
fi

if [ ! -f "$SRC" ]; then
    die "File not found: $SRC"
fi

if [ ! -b "$DST" ]; then
    die "Block device not found: $DST"
fi

echo "Unarchiving $SRC"
bzip2 -d -f $SRC
sudo dd if=${SRC%.bz2} of=$DST

