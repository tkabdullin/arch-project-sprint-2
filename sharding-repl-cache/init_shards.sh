#!/bin/bash



docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard11:27018" },
        { _id : 2, host : "shard111:27018" },
      ]
    }
);
EOF



docker compose exec -T shard2 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2:27018" },
        { _id : 1, host : "shard22:27018" },
        { _id : 2, host : "shard222:27018" },
      ]
    }
);
EOF
