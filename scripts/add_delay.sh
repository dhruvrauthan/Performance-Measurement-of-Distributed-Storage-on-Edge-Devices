#!/bin/bash

interface=ens2
ip=$1
delay=$2ms

sudo tc qdisc add dev $interface root handle 1: prio
sudo tc filter add dev $interface parent 1:0 protocol ip prio 1 u32 match ip ds>
sudo tc qdisc add dev $interface parent 1:1 handle 2: netem delay $delay
