sh.addShard( "shard1/shard1-a:27017");
sh.addShard( "shard1/shard1-b:27017");
sh.addShard( "shard1/shard1-c:27017");

sh.addShard( "shard2/shard2-a:27017");
sh.addShard( "shard2/shard2-b:27017");
sh.addShard( "shard2/shard2-c:27017");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

db.helloDoc.countDocuments()