docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF

rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard1_replica1:27022" }
      ]
    }
);
exit();
EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF

rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 2, host : "shard2:27019" },
        { _id : 3, host : "shard2_replica1:27023" }
      ]
    }
  );
exit();

EOF