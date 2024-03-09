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
set val(row)          [expr ($val(nn)-2) / $val(col)] ;
set val(halfCol)      [expr $val(col) / 2]; 
set val(packetSize)   1000                     ; # packet size
set val(bw)           10mb;
set val(bw1)          150mb;
set val(delay)        2ms;
set val(delay1)       30ms;  

#Open the NAM file and trace file
set nam_file [open animation.nam w]
set trace_file [open trace.tr w]
$ns namtrace-all $nam_file
$ns trace-all $trace_file

expr { srand(11) }

# first two nodes
set node(0) [$ns node]
set node(1) [$ns node]
$ns duplex-link $node(0) $node(1) $val(bw1) $val(delay1) DropTail
$ns queue-limit $node(0) $node(1) 10

# other nodes
for {set i 0} {$i < $val(row) } {incr i} {
    for {set j 0} {$j < $val(col) } {incr j} {
        set var1 [expr ($val(col) * $i + $j + 2)]
        set node($var1) [$ns node]


        set abc [expr ($val(side) / $val(row) * $j + $val(side) / $val(row))]
        set def [expr ($val(side) / $val(row) * ($i + 1) + $val(side) / $val(row))]

        if { $i == 0} {
            if { $j < $val(halfCol)} {
                $ns duplex-link $node(0) $node($var1) $val(bw) $val(delay) DropTail
                $ns queue-limit $node(0) $node($var1) 10
            } else {
                $ns duplex-link $node(1) $node($var1) $val(bw) $val(delay) DropTail
                $ns queue-limit $node(1) $node($var1) 10
        }
        } else {
            set tempVar [expr $var1 - $val(col)]
            $ns duplex-link $node($var1) $node($tempVar) $val(bw) $val(delay) DropTail
            $ns queue-limit $node($var1) $node($tempVar) 10
        }

        
    }    
}

# creating flows
for {set i 0} {$i < $val(nf)} {incr i} {

    # Traffic config

    set tcp [new Agent/TCP/DCVegas]          ; # create agent
    

    set src [expr int(10000 * rand()) % $val(nn)]
    $ns attach-agent $node($src) $tcp          ;# attach agent to node
    while {1} {
        set sink [expr int(10000 * rand()) % $val(nn)]
        if {$src != $sink} {
            break
        }
    }
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
    $ns at 19.5 "$cbr stop"

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