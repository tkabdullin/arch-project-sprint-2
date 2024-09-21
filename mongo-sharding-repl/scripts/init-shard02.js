rs.initiate(
  {
    _id : "rs-shard-02",
    members: [
      { _id : 1, host : "shard02-a:27201" },
      { _id : 2, host : "shard02-b:27202" },
      { _id : 3, host : "shard02-c:27203" },
    ]
  }
);
