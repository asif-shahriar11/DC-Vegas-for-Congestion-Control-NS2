import matplotlib.pyplot as plt 

inputFile = open("output_total.txt", "r")
metrics = ["network_throuhput_(kbits/s)", "end-to-end_avg_delay_(s)", "packet_delivery_ratio", "packet_drop_ratio"]

parameters = []
network_throughputs = []
end_to_end_avg_delays = []
packet_delivery_ratios = []
packet_drop_ratios = []

parameters1 = []
network_throughputs1 = []
end_to_end_avg_delays1 = []
packet_delivery_ratios1 = []
packet_drop_ratios1 = []

flag = 0

for line in inputFile:
    if len(line.split()) == 1:
        parameters.append(int(line))
    elif len(line.split()) <= 3:
        parameter = line
    else:
        split_list = line.split()
        if flag == 0:
            network_throughputs.append(float(split_list[0]))
            end_to_end_avg_delays.append(float(split_list[1]))
            packet_delivery_ratios.append(float(split_list[2]))
            packet_drop_ratios.append(float(split_list[3]))

            flag = 1
        
        else:
            network_throughputs1.append(float(split_list[0]))
            end_to_end_avg_delays1.append(float(split_list[1]))
            packet_delivery_ratios1.append(float(split_list[2]))
            packet_drop_ratios1.append(float(split_list[3]))

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