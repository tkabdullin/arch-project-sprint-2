#!/bin/bash

###
# Инициализируем бд
###

docker compose exec -T config_srv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "configSrv",
    configsvr: true,
    members: [
      { _id : 0, host : "config_srv:27017" }
    ]
  }
);
EOF

sleep 10

docker compose exec -T shard1a mongosh --port 27018 --quiet <<EOF
rs.initiate(
  {
    _id : "shard1rs",
    members: [
      { _id : 0, host : "shard1a:27018" },
      { _id : 1, host : "shard1b:27018" },
      { _id : 2, host : "shard1c:27018" }
    ]
  }
);
EOF

docker compose exec -T shard2a mongosh --port 27019 --quiet <<EOF
rs.initiate(
  {
    _id : "shard2rs",
    members: [
      { _id : 0, host : "shard2a:27019" },
      { _id : 1, host : "shard2b:27019" },
      { _id : 2, host : "shard2c:27019" }
    ]
  }
);
EOF

sleep 10

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF

sh.addShard( "shard1rs/shard1a:27018,shard1b:27018,shard1c:27018");
sh.addShard( "shard2rs/shard2a:27019,shard2b:27019,shard2c:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments()

EOF
