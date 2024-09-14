#!/bin/bash

docker compose exec -T shard1-1 mongosh --port 27018 --quiet  <<EOF

rs.initiate({_id : "shard1", members: [
  { _id : 0, host : "shard1-1:27018" },
  { _id : 1, host : "shard1-2:27016" },
  { _id : 2, host : "shard1-3:27015" }
]});

exit();

EOF

docker compose exec -T shard2-1 mongosh --port 27019 --quiet  <<EOF

rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2-1:27019" },
        { _id : 1, host : "shard2-2:27014" },
        { _id : 2, host : "shard2-3:27013" },
      ]
    }
  );
exit();
EOF
