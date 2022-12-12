from cassandra.cluster import Cluster, ExecutionProfile, EXEC_PROFILE_DEFAULT
from cassandra import ConsistencyLevel
import json
import time

# Set the Cassandra consistency level
profile = ExecutionProfile(
        consistency_level=ConsistencyLevel.QUORUM
)

# Add all the edge node IP addresses into the cluster
cluster = Cluster(['192.168.122.11', '192.168.122.12', '192.168.122.13', '192.168.122.14', '192.168.122.15'], execution_profiles={EXEC_PROFILE_DEFAULT: profile})

# Connect to the database
session = cluster.connect('edgedb')

# Open and load the dataset
f = open('dataset')
data = json.load(f)

# Start the timer
timeStart = time.time()

# Extracting and parsing the data from the dataset
for i in data['prizes']:
        if not i.__contains__('laureates'):
                continue
        for j in i['laureates']:
                firstname = j['firstname']
                if not j.__contains__('surname'):
                        continue
                surname = j['surname']
                year = int(i['year'])
                category = i['category']
                
                # Creating and executing the query
                query = "INSERT INTO prizes(id, first_name, surname, year, category) VALUES (uuid(), %(firstname)s, %(surname)s, %(year)s, %(category)s)"
                session.execute(query, {'firstname': firstname, 'surname': surname, 'year': year, 'category': category})
                
# Stop the timer and print the total time
timeEnd = time.time()
totalTime = (timeEnd - timeStart)*1000
print(str(round(totalTime/1000, 3)) + "ms")

