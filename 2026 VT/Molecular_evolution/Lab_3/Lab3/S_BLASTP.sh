#!/bin/bash -l

BLASTP_PATH=/home/miltr339/molevol/lab3/ncbi-blast-linux/bin/blastp

while getopts q:s:o: flag 
do
case "${flag}" in
                q) QUERY=${OPTARG}
                      ;;
                s) SUBJECT=${OPTARG}
                      ;;
                o) OUT=${OPTARG}
                      ;;
                *) echo "Invalid option: -$flag" 
                  ;;
        esac
done

$BLASTP_PATH -query $QUERY -db $SUBJECT -outfmt 6 > $OUT
echo "Blast results can be found in $OUT"
