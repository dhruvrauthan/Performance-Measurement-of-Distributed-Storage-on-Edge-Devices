#!/bin/bash
#latencies = "0 10 20 30 40 50 60 70 80 90 100"
#packetLoss = "0.5 2.5 7.5"

for latency in 10 20 30 40 50 60 70 80 90 100
do
        for packetLoss in 0.5 2.5 7.5
        do
                ssh edge0@192.168.122.11 -i /home/f20190095/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network 192.168.122.16;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.12;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.13;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.14;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.15;exit;"

                ssh edge1@192.168.122.12 -i /home/f20190095/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network 192.168.122.16;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.13;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.11;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.15;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.14;exit;"

                ssh edge2@192.168.122.13 -i /home/f20190095/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network 192.168.122.16;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.11;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.12;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.15;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.14;exit;"

                ssh edge3@192.168.122.14 -i /home/f20190095/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network 192.168.122.16;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.11;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.12;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.15;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.13;exit;"

                ssh edge4@192.168.122.15 -i /home/f20190095/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network 192.168.122.16;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.11;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.12;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.14;
                tcset --add ens2 --delay $latency --loss $packetLoss --network 192.168.122.13;exit;"
                
                ssh endpoint0@192.168.122.16 -i /home/f20190095/.ssh/id_rsa_benchmark "echo \$(python3 write.py) >> 5_node_rf5.txt; exit;"
        done
        ssh endpoint0@192.168.122.16 -i /home/f20190095/.ssh/id_rsa_benchmark "echo >> 5_node_rf5.txt; exit;"
done
