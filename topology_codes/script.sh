#!/bin/bash
# echo -n > output_total.txt
# echo "Number of Nodes" >> output_total.txt
# for i in 42 62 82 102 122
# do
# 	echo $i >> output_total.txt
# 	ns wireless.tcl $i 20 5 1mb
# 	awk -f parse_wireless_total.awk trace.tr
# 	ns wireless_dcvegas.tcl $i 20 5 1mb
# 	awk -f parse_wireless_total.awk trace.tr
# done
# python3 graphplotter.py

# echo -n > output_total.txt
# echo "Number of Flows" >> output_total.txt
# for i in 10 20 30 40 50
# do
# 	echo $i >> output_total.txt
# 	ns wireless.tcl 42 $i 5 1mb
# 	awk -f parse_wireless_total.awk trace.tr
# 	ns wireless_dcvegas.tcl 42 $i 5 1mb
# 	awk -f parse_wireless_total.awk trace.tr
# done
# python3 graphplotter.py

echo -n > output_total.txt
echo "Node Speed" >> output_total.txt
for i in 5 10 15 20 25
do
	echo $i >> output_total.txt
	ns wireless.tcl 42 20 $i 1mb
	awk -f parse_wireless_total.awk trace.tr
	ns wireless_dcvegas.tcl 42 20 $i 1mb
	awk -f parse_wireless_total.awk trace.tr
done
# python3 graphplotter.py

# echo -n > output_total.txt
# echo "Packet Rate" >> output_total.txt
# for i in 1 2 3 4 5
# do
# 	echo $i >> output_total.txt
# 	ns wireless.tcl 42 20 5 "$i"mb
# 	awk -f parse_wireless_total.awk trace.tr
# 	ns wireless_dcvegas.tcl 42 20 5 "$i"mb
# 	awk -f parse_wireless_total.awk trace.tr
# done
# python3 graphplotter.py

echo "end"