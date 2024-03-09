import matplotlib.pyplot as plt 

inputFile = open("output_total.txt", "r")
metrics = ["network_throuhput_(kbits/s)", "end-to-end_avg_delay_(s)", "packet_delivery_ratio", "packet_drop_ratio", "total_energy_(J)", "avg_energy_per_packet_(J)", "total_retransmit"]

parameters = []
network_throughputs = []
end_to_end_avg_delays = []
packet_delivery_ratios = []
packet_drop_ratios = []
total_energy = []
avg_energy_per_packet = []
total_retransmit = []

parameters1 = []
network_throughputs1 = []
end_to_end_avg_delays1 = []
packet_delivery_ratios1 = []
packet_drop_ratios1 = []
total_energy1 = []
avg_energy_per_packet1 = []
total_retransmit1 = []

flag = 0
parameter = "Node spped"
parameter2 = "Node spped"

for line in inputFile:
    if len(line.split()) == 1:
        parameters.append(int(line))
    elif len(line.split()) <= 3:
        parameter2 = line
    else:
        split_list = line.split()
        if flag == 0:
            network_throughputs.append(float(split_list[0]))
            end_to_end_avg_delays.append(float(split_list[1]))
            packet_delivery_ratios.append(float(split_list[2]))
            packet_drop_ratios.append(float(split_list[3]))
            total_energy.append(float(split_list[4]))
            avg_energy_per_packet.append(float(split_list[5]))
            total_retransmit.append(float(split_list[6]))

            flag = 1
        
        else:
            network_throughputs1.append(float(split_list[0]))
            end_to_end_avg_delays1.append(float(split_list[1]))
            packet_delivery_ratios1.append(float(split_list[2]))
            packet_drop_ratios1.append(float(split_list[3]))
            total_energy1.append(float(split_list[4]))
            avg_energy_per_packet1.append(float(split_list[5]))
            total_retransmit1.append(float(split_list[6]))

            flag = 0

inputFile.close()

plt.plot(parameters, network_throughputs, marker="o", color="b", label="vegas")
plt.plot(parameters, network_throughputs1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[0].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()

plt.plot(parameters, end_to_end_avg_delays, marker="o", color="b", label="vegas")
plt.plot(parameters, end_to_end_avg_delays1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[1].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()

plt.plot(parameters, packet_delivery_ratios, marker="o", color="b", label="vegas")
plt.plot(parameters, packet_delivery_ratios1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[2].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()

plt.plot(parameters, packet_drop_ratios, marker="o", color="b", label="vegas")
plt.plot(parameters, packet_drop_ratios1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[3].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()

plt.plot(parameters, total_energy, marker="o", color="b", label="vegas")
plt.plot(parameters, total_energy1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[4].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()

plt.plot(parameters, avg_energy_per_packet, marker="o", color="b", label="vegas")
plt.plot(parameters, avg_energy_per_packet1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[5].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()

plt.plot(parameters, total_retransmit, marker="o", color="b", label="vegas")
plt.plot(parameters, total_retransmit1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[6].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()