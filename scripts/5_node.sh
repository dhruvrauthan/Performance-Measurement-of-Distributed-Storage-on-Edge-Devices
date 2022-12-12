#!/bin/bash

# Loop for all latencies up to 100 (in increments of 10)
for latency in 10 20 30 40 50 60 70 80 90 100
do
        # Loop for 3 different packet losses
        for packetLoss in 0.5 2.5 7.5
        do
                # SSH into the edge VM and add the network latency and packet loss
                ssh edge0@$E0 -i ~/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network $EP;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E1;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E2;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E3;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E4;exit;"

                ssh edge1@$E1 -i ~/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network $EP;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E2;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E0;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E4;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E3;exit;"

                ssh edge2@$E2 -i ~/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network $EP;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E0;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E1;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E4;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E3;exit;"

                ssh edge3@$E3 -i ~/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network $EP;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E0;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E1;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E4;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E2;exit;"

                ssh edge4@$E4 -i ~/.ssh/id_rsa_benchmark "tcdel --all ens2;
                tcset --add ens2 --delay 10ms --network $EP;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E0;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E1;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E3;
                tcset --add ens2 --delay $latency --loss $packetLoss --network $E2;exit;"
                
                # SSH into the endpoint VM and write the results into a file
                ssh endpoint0@$EP -i ~/.ssh/id_rsa_benchmark "echo \$(python3 write.py) >> 5_node_rf$RF.txt; exit;"
        done
        ssh endpoint0@$EP -i ~/.ssh/id_rsa_benchmark "echo >> 5_node_rf$RF.txt; exit;"
done
