from cassandra.cluster import Cluster, ExecutionProfile, EXEC_PROFILE_DEFAULT
from cassandra import ConsistencyLevel
import json
import time

profile = ExecutionProfile(
        consistency_level=ConsistencyLevel.TWO
)

cluster = Cluster(['192.168.122.11', '192.168.122.12', '192.168.122.13'], execution_profiles={EXEC_PROFILE_DEFAULT: profile})
session = cluster.connect('edgedb')

print("Connected to Database!")
print("Writing Data...")

f = open('sampledata')
data = json.load(f)

timeStart = time.time()
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
                query = "INSERT INTO prizes(id, first_name, surname, year, category) VALUES (uuid(), %(firstname)s, %(surname)s, %(year)s, %(category)s)"
                session.execute(query, {'firstname': firstname, 'surname': surname, 'year': year, 'category': category})
timeEnd = time.time()
totalTime = (timeEnd - timeStart)*1000
print("Total time taken : " + str(round(totalTime, 3)) + "ms")
print("Average Latency : " + str(round(totalTime/945, 3)) + "ms")


