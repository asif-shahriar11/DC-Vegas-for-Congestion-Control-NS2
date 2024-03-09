#Create a simulator object
set ns [new Simulator]

# Define different colors for data flows (for NAM)
$ns color 1 green
$ns color 2 Orange
$ns color 3 Red

# variables
set val(side)         500
set val(nn)           [lindex $argv 0]        ; # number of mobilenodes
set val(nf)           [lindex $argv 1]        ;
set val(packetRate)   [lindex $argv 2] ;

# fixed
set val(col)          20                       ; # number of cols in grid
set val(row)          [expr ($val(nn)-32) / $val(col)] ;
set val(halfCol)      [expr $val(col) / 2]; 
set val(packetSize)   1000                     ; # packet size

set val(bw)           800mb;
set val(rackbw)       500mb;
set val(delay)        10ms;

#Open the NAM file and trace file
set nam_file [open animation.nam w]
set trace_file [open trace.tr w]
$ns namtrace-all $nam_file
$ns trace-all $trace_file

expr { srand(11) }


# topology
# first two nodes - core switch
set node(0) [$ns node]
set node(1) [$ns node]
# next 10 nodes - aggretion switches, each connected with both core switches
for {set i 0} {$i < 10 } {incr i} {
    set temp [expr $i + 2]
    set node($temp) [$ns node]
    $ns duplex-link $node(0) $node($temp) $val(bw) $val(delay) DropTail
    $ns queue-limit $node(0) $node($temp) 10
    $ns duplex-link $node(1) $node($temp) $val(bw) $val(delay) DropTail
    $ns queue-limit $node(1) $node($temp) 10
}
# next 20 nodes - top rack switches
set aggnode 2
for {set i 0} {$i < 20 } {incr i} {
    set temp [expr $i + 12]
    set node($temp) [$ns node]
    $ns duplex-link $node($aggnode) $node($temp) $val(bw) $val(delay) DropTail
    $ns queue-limit $node($aggnode) $node($temp) 10
    set temp2 [expr ($i % 2)]
    if { $temp2 == 1 } {
        incr aggnode
    }
}

# all others are dc servers
for {set i 0} {$i < $val(row) } {incr i} {
    for {set j 0} {$j < $val(col) } {incr j} {
        set var1 [expr ($val(col) * $i + $j + 32)]
        set node($var1) [$ns node]

        set tempVar [expr $var1 - $val(col)]
        $ns duplex-link $node($var1) $node($tempVar) $val(rackbw) $val(delay) DropTail
        $ns queue-limit $node($var1) $node($tempVar) 10       
    }    
}

# first two nodes
# set node(0) [$ns node]
# set node(1) [$ns node]
# $ns duplex-link $node(0) $node(1) 150Mb 30ms DropTail
# $ns queue-limit $node(0) $node(1) 10

# # other nodes
# for {set i 2} {$i < $val(nn) } {incr i} {
#     set node($i) [$ns node]
#     set tempVar [expr $val(nn) - 1]
#         if { $i ==  $tempVar } {
#             $ns duplex-link $node(1) $node($i) 500Mb 2ms DropTail
#             $ns queue-limit $node(1) $node($i) 10
#         } else {
#             $ns duplex-link $node(0) $node($i) 500Mb 2ms DropTail
#             $ns queue-limit $node(0) $node($i) 10
#         }  
# }

# one sink - multiple senders
set sink [expr $val(nn) - 1]

# creating flows
for {set i 0} {$i < $val(nf)} {incr i} {

    # Traffic config

    set tcp [new Agent/TCP/Vegas]          ; # create agent
    
    set range [expr ($val(nn) - 32) ]
    while {1} {
        set src [expr int(10000 * rand()) % $range + 32]
        if {$src != $sink} {
            break
        }
    }
    $ns attach-agent $node($src) $tcp          ;# attach agent to node
    set tcp_sink [new Agent/TCPSink]              ;# create sink agent
    $ns attach-agent $node($sink) $tcp_sink       ;# attach sink agent to node
    

    $ns connect $tcp $tcp_sink                 ;# connect agents
    $tcp set fid_ $i

    # Traffic generator
    set cbr [new Application/Traffic/CBR]      ;# create traffic generator
    $cbr attach-agent $tcp                     ;# attach traffic generator to agent

    # Traffic config parameters
    $cbr set type_ CBR                        ;# packet type
    $cbr set packetSize_  $val(packetSize)    ;# packet size
    $cbr set rate_ $val(packetRate)           ;# sending rate
    $cbr set random_ false

    # start traffic generation
    $ns at 1.0 "$cbr start"
    $ns at 20.0 "$cbr stop"

}

# Stop nodes
# for {set i 0} {$i < $val(nn)} {incr i} {
#     $ns at 20.0 "$node($i) reset"
# }

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

$ns at 20.0001 "finish"
$ns at 20.0002 "halt_simulation"

# Run simulation
puts "Simulation starting"
$ns run