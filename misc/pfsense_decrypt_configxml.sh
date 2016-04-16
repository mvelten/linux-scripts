#!/bin/sh

USAGE="$0 encrypted_config.xml"

if [ $# -ne "1" ]
then
	echo $USAGE
	exit 1
fi

TMP_FILE=tmp_$1

sed '1d' $1 > $TMP_FILE.base64
sed -i '$d' $TMP_FILE.base64

base64 -d $TMP_FILE.base64 > $TMP_FILE.enc
openssl enc -d -aes-256-cbc -in $TMP_FILE.enc -out $1_dec.xml

rm $TMP_FILE.*

exit 0
