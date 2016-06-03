#/bin/bash

USAGE="$0 INPUT_FILE OUTPUT_FILE"

if [[ $# != 2 ]]
then
	echo $USAGE
	exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$2

THREADS=`grep processor /proc/cpuinfo | wc -l`
BITRATE=2M

ffmpeg -i ${INPUT_FILE} -threads $THREADS -r 30 -c:v libvpx -b:v $BITRATE ${OUTPUT_FILE}

exit 0
