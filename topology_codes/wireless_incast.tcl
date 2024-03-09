# simulator
set ns [new Simulator]


# ======================================================================
# Define options

set val(chan)         Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
set val(ifqlen)       50                       ;# max packet in ifq
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type
set val(rp)           AODV                     ;# ad-hoc routing protocol 
# =======================================================================

# variables
set val(side)         500
set val(nn)           [lindex $argv 0]        ; # number of mobilenodes
set val(nf)           [lindex $argv 1]        ;
set val(speed)        [lindex $argv 2]                        ; # speed in m/s 
set val(packetRate)   [lindex $argv 3] ;

# fixed
set val(col)          20                       ; # number of cols in grid
set val(row)          [expr ($val(nn)-2) / $val(col)] ;
set val(halfCol)      [expr $val(col) / 2]; 
set val(packetSize)   1000                     ; # packet size

# trace file
set trace_file [open trace.tr w]
$ns trace-all $trace_file

# nam file
set nam_file [open animation.nam w]
$ns namtrace-all-wireless $nam_file $val(side) $val(side)

# topology: to keep track of node movements
set topo [new Topography]
$topo load_flatgrid $val(side) $val(side) ;# 500m x 500m area


# general operation director for mobilenodes
create-god $val(nn)

$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -energyModel    "EnergyModel" \
                -initialEnergy  50.0 \
                -rxPower        0.9 \
                -txPower        0.5 \
                -idlePower      0.45 \
                -sleepPower     0.01 \
                -channelType $val(chan) \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF

# first two nodes
set node(0) [$ns node]
set node(1) [$ns node]
$node(0) set X_ [expr ($val(side) / $val(row))]
$node(0) set Y_ [expr ($val(side) / $val(row))]
$node(0) set Z_ 0
$node(0) random-motion 0 
$ns initial_node_pos $node(0) 20
$node(1) set X_ [expr ($val(side) / $val(row) * 2)]
$node(1) set Y_ [expr ($val(side) / $val(row))]
$node(1) set Z_ 0
$node(1) random-motion 0 
$ns initial_node_pos $node(1) 20

# other nodes
for {set i 0} {$i < $val(row) } {incr i} {
    for {set j 0} {$j < $val(col) } {incr j} {
        set var [expr ($val(col) * $i + $j + 2)]
        set node($var) [$ns node]
        $node($var) random-motion 0       ;# disable random motion

        $node($var) set X_ [expr ($val(side) / $val(row) * $j + $val(side) / $val(row))]
        $node($var) set Y_ [expr ($val(side) / $val(row) * ($i + 1) + $val(side) / $val(row))]
        $node($var) set Z_ 0

        $ns initial_node_pos $node($var) 20
        
    }    
}

# producing node movements with uniform random speed
for {set i 0} {$i < $val(nn)} {incr i} {
    # set destX [expr int(10000 * rand()) % $val(side) + 0.5]
    # set destY [expr int(10000 * rand()) % $val(side) + 0.5]
    # set speed [expr int(100 * rand()) % 5 + 1]
    # $ns at 10.0 "$node($i) setdest [expr int(10000 * rand()) % $val(side) + 0.5] [expr int(10000 * rand()) % $val(side) + 0.5] [expr int(100 * rand()) % 5 + 1]"
    $ns at 10.0 "$node($i) setdest [expr int(10000 * rand()) % $val(side) + 0.5] [expr int(10000 * rand()) % $val(side) + 0.5] $val(speed)"

}

# generating traffic/flow
# one sink - many senders
set dest [expr $val(nn) - 1]

for {set i 0} {$i < $val(nf)} {incr i} {
    set src [expr int(10000 * rand()) % $val(nn)]

    # Traffic config
    # create agent
    set tcp [new Agent/TCP/Vegas]
    set tcp_sink [new Agent/TCPSink]
    # attach to nodes
    $ns attach-agent $node($src) $tcp
    $ns attach-agent $node($dest) $tcp_sink
    # connect agents
    $ns connect $tcp $tcp_sink
    $tcp set fid_ $i

    # creating application-layer traffic/flow generator
    set cbr [new Application/Traffic/CBR]

    # attaching traffic/flow generator to agent
    $cbr attach-agent $tcp

    # configuring traffic/flow generator
    $cbr set type_ CBR
    $cbr set packetSize_  $val(packetSize)    ;# packet size
    $cbr set rate_ $val(packetRate)           ;# sending rate
    $cbr set random_ false

    # starting traffic/flow generation
    $ns at 1.0 "$cbr start"

}



# End Simulation

# Stop nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 50.0 "$node($i) reset"
}

# call final function
proc finish {} {
    global ns trace_file nam_file
    $ns flush-trace
    close $trace_file
    close $nam_file
}

proc halt_simulation {} {
    global ns
    puts "Simulation ending"
    $ns halt
}

$ns at 50.0001 "finish"
$ns at 50.0002 "halt_simulation"




# Run simulation
puts "Simulation starting"
$ns run