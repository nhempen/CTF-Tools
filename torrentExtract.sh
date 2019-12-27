#!/bin/bash
##Replace the X.X.X.X with the IP of the source host sending the bit torrent data and XXXX with the file name of the packet caputre
## At the bottom line replace XXXX.XXX with the file name and extension of the file that is going to be extracted

tshark -r XXXXX.pcap -Y 'ip.src == X.X.X.X and bittorrent.piece.index' -T fields -e 'bittorrent.piece.index' -e 'bittorrent.piece.data' -E aggregator=, > dump.txt

rm -rf output.txt
cat dump.txt |while read LINE;do
 INDARR=()
 DATAARR=()
 INDEXS="`echo $LINE | cut -d "+" -f1 |tr "," " "`"
 DATA="`echo $LINE | cut -d "+" -f2 | tr "," " "`"
 i=0
 for ID in $(echo $INDEXS);do
	 INDARR[$i]="$ID"
	 let i++
 done
 i=0
 for DAT in $(echo $DATA);do
	 DATAARR[$i]="$DAT"
	 let i++
 done
 i=0
 for ((i=0; i < ${#INDARR[@]}; i++)); do
	 echo "${INDARR[$i]}=${DATAARR[$i]}" >> output.txt
 done
done

for line in $(cat output.txt|cut -d "=" -f1);do printf "%d\n" $line;done >decorder.txt
for line in $(cat order.txt);do printf "%x\n" $line;done >hexorder.txt
for line in $(cat hexorder.txt);do  grep "0x0*${line}=" output.txt|cut -d "=" -f2 >>finished.txt; done
cat finished.txt |tr -d "\n" > second.txt
xxd -r -p second.txt > XXXX.XXX

