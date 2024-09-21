docker compose exec -T router1 mongosh --port 27020 --quiet <<EOF

sh.addShard( "shard1/shard1:27018,shard1_replica1:27022");
sh.addShard( "shard2/shard2:27019,shard2_replica1:27023");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

db.helloDoc.countDocuments() 
exit();
EOF

docker compose exec -T router2 mongosh --port 27021 --quiet <<EOF

sh.addShard( "shard1/shard1:27018,shard1_replica1:27022");
sh.addShard( "shard2/shard2:27019,shard2_replica1:27023");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

exit();
EOF