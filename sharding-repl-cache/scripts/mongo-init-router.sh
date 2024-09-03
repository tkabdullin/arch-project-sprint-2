#!/bin/bash

### Инициализация роутера шардирования

docker compose exec -T mongos_router mongosh --port 27021 --quiet <<EOF
sh.addShard( "shard1/shard1-1:27018");
sh.addShard( "shard2/shard2-1:27018");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF
