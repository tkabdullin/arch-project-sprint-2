#!/bin/bash



docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard11 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard111 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

#################################

docker compose exec -T shard2 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard22 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard222 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF
