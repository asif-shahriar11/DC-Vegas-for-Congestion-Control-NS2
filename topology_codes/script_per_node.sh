#!/bin/bash
echo -n > output_per_node.txt
#echo "Number of Nodes" >> output_per_node.txt
for i in 42 62 82 102
do
	#echo $i >> output_per_node.txt
	echo "check 0" >> output_per_node.txt
    ns wireless.tcl $i 20 5 1mb
	awk -f parse_wireless_per_node.awk trace.tr
	echo "check 1" >> output_per_node.txt
    ns wireless_dcvegas.tcl $i 20 5 1mb
	awk -f parse_wireless_per_node.awk trace.tr
    python3 graphplotter_per_node.py
done
#python3 graphplotter.py

echo -n > output_per_node.txt
#echo "Number of Flows" >> output_per_node.txt
for i in 10 20 30 40 50
do
	#echo $i >> output_per_node.txt
	echo "check 0" >> output_per_node.txt
    ns wireless.tcl 42 $i 5 1mb
	awk -f parse_wireless_per_node.awk trace.tr
	echo "check 1" >> output_per_node.txt
    ns wireless_dcvegas.tcl 42 $i 5 1mb
	awk -f parse_wireless_per_node.awk trace.tr
    python3 graphplotter_per_node.py
done
# python3 graphplotter.py
