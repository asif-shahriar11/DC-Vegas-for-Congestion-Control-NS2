# DC-Vegas: A Delay-based Congestion Control Algorithm for Datacenters (NS2 Implementaion)

Traditional TCP congestion control algorithms designed for the Internet environments encounter many problems in datacenter networks, like **soft latency** and **huge throughput loss**
in **incast** scenarios. Many solutions have been proposed to overcome this. Algorithms like **DC-TCP**  achieved excellent performance in laboratorial datacenter networks, but cannot
be readily deployed in existing datacenters due to various limitations of the datacenters. On the other hand, delay-based algorithms like **TCP Vegas** perform well
for reducing transmission latency, but poorly in incast scenarios. Based on this insight, **DC-Vegas** combines the low-cost deployment advantage of TCP Vegas and the excellent performance of
DC-TCP in datacenters. NS-2 simulation shows that DC-Vegas can produce better
throughput and packet delivery ratios than TCP-Vegas while the
average end-to-end delay is just slightly higher.

## Performance Metrics

- Network Throughput
- End-to-end Delay
- Packet Delivery Ratio
- Packet Drop Ratio
- Total Energy
- Average Energy per Packet
- Per Node Throughput
- Per Node Energy Consumption
- Per Node Residual Energy

## Variable Parameters

- Number of nodes
- Number of flows
- Packets per second
- Node speed (for wireless only)

## Algorithm

When all packets in the same window are acknowledged,

```latex
F_{dcv} = \frac{\text{number of ACKs with } q > k_{dcv}}{\text{Total number of ACKs in the window}}
\alpha_{dcv} = (1 - g) \times \alpha_{dcv} + g \times F_{dcv}
```

Now the window size can be updated in each RTT using the following equation:


```latex
cwnd = 
\begin{cases} 
cwnd - \frac{\alpha_{dcv}}{2}, & \text{if } F_{dcv} > 0 \\
cwnd + \frac{1}{cwnd}, & \text{if } F_{dcv} = 0 
\end{cases}
```

## Summary Findings

### In wired network:

- As the number of flows and packet rate increase, DCVegas performs better than TCP-Vegas; with better packet
delivery ratio and similar throughput and delay
- As the number of nodes increase, DC-Vegas and TCPVegas perform roughly equal

### In wireless network:

-  DC-Vegas almost always have better throughput and
better packet delivery ratio than TCP-Vegas
- TCP-Vegas has lower end-to-delay than DC-Vegas
- DC-Vegas graphs appear to be more consistent


