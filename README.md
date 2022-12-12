# Performance Measurement of Distributed Storage on Edge Devices

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
3. Run `python3 main.py configuration/infra_only.cfg` from the `continuum` directory.
4. Wait a few minutes for the VMs to be deployed. Note down the SSH commands and IPs for the created VMs. 
5. Run `virsh list` to check if the VMs are up and running.
6. Run `nano ~/.bashrc`
7. At the end of the file, add the variables for the VM IP addresses and replace the IP addresses with the ones you noted down earlier:
    ```
    export E0="<edge0_ip_address>"
    export E1="<edge1_ip_address>"
    export E2="<edge2_ip_address>"
    export E3="<edge3_ip_address>"
    export E4="<edge4_ip_address>"
    export EP="<endpoint_ip_address>"
    ```

Note: The IP addresses used for our experiments are 192.168.122.11, 192.168.122.12, 192.168.122.13, 192.168.122.14, 192.168.122.15, 192.168.122.16. These may be different according to your network configuration. You may substitute the IP addresses in the following commands accordingly.

### Part 2: Cassandra

1. Use one of the previous commands to SSH into an edge VM. 
For example: `ssh edge0@$E0 -i ~/.ssh/id_rsa_benchmark`
2. Run `nano cassandra_setup.sh`
3. Paste the contents from `scripts/cassandra_setup` into the previous file.
4. Exit the editor and run `chmod +x cassandra_setup.sh`
5. Run `./cassandra_setup.sh`
6. Wait a few minutes for the installation to complete
7. Edit the `/etc/cassandra/cassandra.yaml` file to change the following fields:

    a) Change the `seeds` field to include the IP addresses of all the edge VMs.
    
    For example: `seeds: "127.0.0.1:7000, 192.168.122.11, 192.168.122.12, 192.168.122.13, 192.168.122.14, 192.168.122.15"`
    
    b) Change the `listen_address` and `rpc_address` fields to match the IP address of the current node.
    
    For example, for edge0: `listen_address: 192.168.122.11`, `rpc_address: 192.168.122.11`
    
    c) Add `auto_bootstrap: false` at the end of the file
    
8. To allow Cassandra communication between nodes, run the following command (replace `<ip_address>` with the IP address of every other node):

    ```
    sudo iptables -A INPUT -p tcp -s <ip_address> -m multiport --dports 7000,9042 -m state --state NEW,ESTABLISHED -j ACCEPT
    ```

    For example, for edge0, we will run:
    ```
    sudo iptables -A INPUT -p tcp -s 192.168.122.12 -m multiport --dports 7000,9042 -m state --state NEW,ESTABLISHED -j ACCEPT
    sudo iptables -A INPUT -p tcp -s 192.168.122.13 -m multiport --dports 7000,9042 -m state --state NEW,ESTABLISHED -j ACCEPT
    sudo iptables -A INPUT -p tcp -s 192.168.122.14 -m multiport --dports 7000,9042 -m state --state NEW,ESTABLISHED -j ACCEPT
    sudo iptables -A INPUT -p tcp -s 192.168.122.15 -m multiport --dports 7000,9042 -m state --state NEW,ESTABLISHED -j ACCEPT
    ```
    
9. Run `sudo service cassandra restart`
10. Repeat steps 1-9 for each edge node
11. Run `nodetool status` to check all the nodes are up and communicating with each other.
12. In any 1 node, run the following commands (replace x with the required Replication Factor):
    ```
    cqlsh <ip_address_of_any_other_node>
    CREATE KEYSPACE edgedb WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : x};
    USE edgedb;
    CREATE TABLE prizes(id uuid primary key, first_name text, surname text, year int, category text);
    ```
13. Now our Cassandra cluster is up and running, and ready for experiments.

### Part 3: Network
1. SSH into the VM.
2. Run `nano delay_setup.sh`
3. Paste the contents from `scripts/delay_setup` into the previous file.
4. Exit the editor and run `chmod +x delay_setup.sh`
5. Run `./delay_setup.sh`
6. Repeat steps 1-5 for every VM (all edge VMs and endpoint).

### Part 4: Endpoint
1. SSH into the endpoint.
2. Run `nano write.py`
3. Paste the contents from `scripts/write.py` into the previous file.
4. Exit the editor and run `chmod +x write.py`
5. Repeat steps 1-3 for `scripts/sampledata` as well.

## Experimentation
1. Run the `scripts/x_node.sh` script where x = 3, 4 or 5
2. For the output, SSH into the endpoint VM and view the `x_node_rfy.txt`, where x = 3, 4 or 5 and y = the previously set Replication Factor
