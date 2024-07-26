#!/bin/bash

###
# Заполнение бд
###

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1_master:27010");
sh.addShard("shard1/shard1_slave1:27011");
sh.addShard("shard1/shard1_slave2:27012");
sh.addShard("shard2/shard2_master:27013");
sh.addShard("shard2/shard2_slave1:27014");
sh.addShard("shard2/shard2_slave2:27015");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb;

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})

db.helloDoc.countDocuments();
EOF
