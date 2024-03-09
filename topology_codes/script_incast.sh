#!/bin/bash
echo -n > output_total.txt
echo "Number of senders" >> output_total.txt
for i in 10 20 30 40 50
do
	echo $i >> output_total.txt
	ns wireless_incast.tcl 62 $i 5 1mb
	awk -f parse_wireless_total.awk trace.tr
	ns wireless_incast_dcvegas.tcl 62 $i 5 1mb
	awk -f parse_wireless_total.awk trace.tr
done
python3 graphplotter.py


echo "end"