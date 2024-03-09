import matplotlib.pyplot as plt 

inputFile = open("output_per_node.txt", "r")
metrics = ["energy_consumption_(J)", "residual_energy_(J)", "throughput_(bits/s)"]

parameters = []
throughputs = []
energy_consumption = []
residual_energy = []

parameters1 = []
throughputs1 = []
energy_consumption1 = []
residual_energy1 = []

parameter = "node"

flag = 0

for line in inputFile:
    if len(line.split()) == 1:
        if flag == 0:
            parameters.append(int(line))
        else:
            parameters1.append(int(line))
            
    elif len(line.split()) == 2:
        split_list1 = line.split()
        flag = int(split_list1[1])
    else:
        split_list = line.split()
        if flag == 0:
            energy_consumption.append(float(split_list[0]))
            residual_energy.append(float(split_list[1]))
            throughputs.append(float(split_list[2]))
        
        else:
            energy_consumption1.append(float(split_list[0]))
            residual_energy1.append(float(split_list[1]))
            throughputs1.append(float(split_list[2]))


inputFile.close()

plt.scatter(parameters, throughputs, marker="o", color="b", label="vegas")
plt.scatter(parameters1, throughputs1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[2].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()

plt.scatter(parameters, energy_consumption, marker="o", color="b", label="vegas")
plt.scatter(parameters1, energy_consumption1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[0].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()

plt.scatter(parameters, residual_energy, marker="o", color="b", label="vegas")
plt.scatter(parameters1, residual_energy1, marker="o", color="r", label="dc-vegas")
plt.ylabel(metrics[1].replace("_", " "))
plt.xlabel(parameter.replace("_", " "))
plt.show()