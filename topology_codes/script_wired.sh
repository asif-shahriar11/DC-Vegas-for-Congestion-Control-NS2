#!/bin/bash
# echo -n > output_total.txt
# echo "Number of Nodes" >> output_total.txt
# for i in 42 62 82 102 122
# do
# 	echo $i >> output_total.txt
# 	ns wired.tcl $i 20 1mb
# 	awk -f parse_wired.awk trace.tr
# 	ns wired_dcvegas.tcl $i 20 1mb
# 	awk -f parse_wired.awk trace.tr
# done
# python3 graphplotter_wired.py

echo -n > output_total.txt
echo "Number of Flows" >> output_total.txt
for i in 10 20 30 40 50
do
	echo $i >> output_total.txt
	ns wired.tcl 42 $i 1mb
	awk -f parse_wired.awk trace.tr
	ns wired_dcvegas.tcl 42 $i 1mb
	awk -f parse_wired.awk trace.tr
done
python3 graphplotter_wired.py

# echo -n > output_total.txt
# echo "Packet Rate" >> output_total.txt
# for i in 1.0 1.25 1.5 1.75 2.0
# do
# 	echo $i >> output_total.txt
# 	ns wired.tcl 42 20 "$i"mb
# 	awk -f parse_wired.awk trace.tr
# 	ns wired_dcvegas.tcl 42 20 "$i"mb
# 	awk -f parse_wired.awk trace.tr
# done
# python3 graphplotter_wired.py

echo "end"