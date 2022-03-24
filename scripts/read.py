from cassandra.cluster import Cluster, ExecutionProfile, EXEC_PROFILE_DEFAULT
from cassandra import ConsistencyLevel
import json
import time

profile = ExecutionProfile(
        consistency_level=ConsistencyLevel.ONE
)

cluster = Cluster(['192.168.122.11', '192.168.122.12', '192.168.122.13'], execu>
session = cluster.connect('edgedb')

print("Connected to Database!")
print("Reading Data...")

timeStart = time.time()
query = "SELECT * FROM prizes"
session.execute(query)
timeEnd = time.time()
totalTime = (timeEnd - timeStart)*1000
print("Total time taken : " + str(round(totalTime, 3)) + "ms")
print("Average Latency : " + str(round(totalTime/945, 3)) + "ms")
