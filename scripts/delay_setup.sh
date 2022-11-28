#!/bin/bash

sudo apt install python3-pip
sudo pip3 install tcconfig
sudo pip install cassandra-driver # Only for endpoint
sudo setcap cap_net_admin+ep /usr/sbin/tc
