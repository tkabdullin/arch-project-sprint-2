docker compose exec -T shard1 mongosh --port 27031 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-a:27031" },
        { _id : 1, host : "shard1-b:27032" },
        { _id : 2, host : "shard1-c:27033" },
      ]
    }
);
exit();
EOF

docker compose exec -T shard2 mongosh --port 27041 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
       { _id : 0, host : "shard2-a:27041" },
       { _id : 1, host : "shard2-b:27042" },
       { _id : 2, host : "shard2-c:27043" },
      ]
    }
  );
exit();
EOF