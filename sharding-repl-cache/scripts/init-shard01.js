rs.initiate(
  {
    _id : "rs-shard-01",
    members: [
      { _id : 0, host : "shard01-a:27101" },
      { _id : 1, host : "shard01-b:27102" },
      { _id : 2, host : "shard01-c:27103" },
    ]
  },
);
