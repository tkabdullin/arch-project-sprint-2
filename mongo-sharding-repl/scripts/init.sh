#!/bin/bash

###
# Инициализируем бд
###

docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config-server",
    configsvr: true,
    members: [
      { _id : 0, host : "config-srv:27017" }
    ]
  }
);
EOF

docker compose exec -T shard1_master mongosh --port 27010 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1_master:27010" },
        { _id : 1, host : "shard1_slave1:27011" },
        { _id : 2, host : "shard1_slave2:27012" },
      ]
    }
);
EOF

docker compose exec -T shard2_master mongosh --port 27013 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2_master:27013" },
        { _id : 1, host : "shard2_secondary1:27014" },
        { _id : 2, host : "shard2_secondary2:27015" }
      ]
    }
);
EOF
