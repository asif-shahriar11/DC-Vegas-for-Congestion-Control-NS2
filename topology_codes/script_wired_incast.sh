#!/bin/bash
echo -n > output_total.txt
echo "Number of senders" >> output_total.txt
for i in 10 20 30 40 50
do
	echo $i >> output_total.txt
	ns wired_incast.tcl 72 $i 500kb
	awk -f parse_wired.awk trace.tr
	ns wired_incast_dcvegas.tcl 72 $i 500kb
	awk -f parse_wired.awk trace.tr
done
python3 graphplotter_wired.py

echo "end"