#!/bin/bash

docker compose exec -T mongos_router mongosh --port 27020 --quiet  <<EOF

sh.addShard( "shard1/shard1-1:27018,shard1-2:27016,shard1-3:27015");
sh.addShard( "shard2/shard2-1:27019,shard2-2:27014,shard2-3:27013");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})

db.helloDoc.countDocuments()
exit();

EOF
