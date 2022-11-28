# Edge-Cassandra

This repository is used to analyze Cassandra’s performance in different networks. 
We vary Cassandra’s attributes and the overall conditions in each network to simulate a real-world scenario and study 
the effect on the total time taken for a particular request.

## Setup

### Part 1: Continuum

1. Clone the repository into your host machine.
2. Edit `continuum/configuration/infra_only.cfg` to set the number of nodes and cores according to your machine's capability.
We have set it as follows:
```
cloud_nodes = 1
edge_nodes = 5
endpoint_nodes = 1

cloud_cores = 4
edge_cores = 2
endpoint_cores = 1
```
3. Run `python3 main.py configuration/infra_only.cfg` from the `continuum` directory
4. Wait a few minutes for the VMs to be deployed
5. Run `virsh list` to check if the VMs are up and running.

### Part 2: Cassandra


### Part 3: Network
