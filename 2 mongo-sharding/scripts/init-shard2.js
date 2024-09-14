rs.initiate(
    {
      _id : "shard2",
      members: [
        // { _id : 0, host : "shard1:27018" },
       { _id : 1, host : "shard2:27019" }
      ]
    }
);