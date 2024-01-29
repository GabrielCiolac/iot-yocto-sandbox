#!/usr/bin/env bash


META_POKY="https://git.yoctoproject.org/git/poky"
META_RASP="https://git.yoctoproject.org/git/meta-raspberrypi"
META_OPENEMBEDDED="https://git.openembedded.org/meta-openembedded"



die () {
    echo "ERROR: $1"
    exit 1
}

usage (){
    echo "Usage: $0 --poky-version"
    echo "--poky-version: poky version (e.g. kirkstone, dunfell, gatesgarth)"
}

cloned () {
    test -d $1
}

clone () {
    # clone and checkout poky-version
    git clone $1
    cd $2
    git checkout $3
}

while [ $# -gt 0 ]; do
    case "$1" in
        --poky-version)
            POKY_VERSION=$2
            shift 2
            ;;
        *)
            usage
            die "Unknown argument: $1"
            ;;
    esac
done

if [ -z "$POKY_VERSION" ]; then
    usage
    die "Missing arguments"
fi

cloned poky || clone $META_POKY poky $POKY_VERSION
config
cd poky
cloned meta-raspberrypi || clone $META_RASP meta-raspberrypi $POKY_VERSION || die "Failed to clone meta-raspberrypi"
cloned meta-openembedded || clone $META_OPENEMBEDDED meta-openembedded $POKY_VERSION || die "Failed to clone meta-openembedded"


