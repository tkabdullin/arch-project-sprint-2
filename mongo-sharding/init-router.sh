
#!/bin/bash


docker compose exec -T mongos_router mongosh --port 27017 <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
EOF
