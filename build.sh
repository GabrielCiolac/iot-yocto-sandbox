#!/usr/bin/env bash

config ()
{
    cp $1 conf/
}

write-machine-config ()
{
    echo "MACHINE = \"$1\"" >> $2
    echo $PWD/$2
    cat $2
}

usage ()
{
    echo "Usage: $0 --target (e.g. raspberrypi3, raspberrypi4, qemux86-64)"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --target)
            TARGET=$2
            shift 2
            ;;
        *)
            usage
            die "Unknown argument: $1"
            ;;
    esac
done

PATH_LOCAL_CONF=${PWD}/local.conf
PATH_BBLAYERS_CONF=${PWD}/bblayers.conf

cd poky
source oe-init-build-env build
config $PATH_LOCAL_CONF
write-machine-config $TARGET conf/local.conf
config $PATH_BBLAYERS_CONF
bitbake core-image-base
