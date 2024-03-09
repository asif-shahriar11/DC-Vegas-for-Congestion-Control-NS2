# DC-Vegas: A Delay-based Congestion Control Algorithm for Datacenters (NS2 Implementaion)

Traditional TCP congestion control algorithms designed for the Internet environments encounter many problems in datacenter networks, like **soft latency** and **huge throughput loss**
in **incast** scenarios. Many solutions have been proposed to overcome this. Algorithms like **DC-TCP**  achieved excellent performance in laboratorial datacenter networks, but cannot
be readily deployed in existing datacenters due to various limitations of the datacenters. On the other hand, delay-based algorithms like **TCP Vegas** perform well
for reducing transmission latency, but poorly in incast scenarios. Based on this insight, **DC-Vegas** combines the low-cost deployment advantage of TCP Vegas and the excellent performance of
DC-TCP in datacenters. NS-2 simulation shows that DC-Vegas can produce better
throughput and packet delivery ratios than TCP-Vegas while the
average end-to-end delay is just slightly higher.

## Topology

![An example datacenter topology](https://drive.google.com/file/d/15ZPwDyq1yUmND_0q1KjNpSjRIdf2Tzv3/view?usp=sharing "Datacenter Topology")
