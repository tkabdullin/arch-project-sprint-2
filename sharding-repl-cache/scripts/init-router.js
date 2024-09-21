sh.addShard( "rs-shard-01/shard01-a:27101");
sh.addShard( "rs-shard-01/shard01-b:27102");
sh.addShard( "rs-shard-01/shard01-c:27103");
sh.addShard( "rs-shard-02/shard02-a:27201");
sh.addShard( "rs-shard-02/shard02-b:27202");
sh.addShard( "rs-shard-02/shard02-c:27203");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
