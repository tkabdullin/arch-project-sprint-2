#!/bin/sh

docker compose exec -T shard2-0 mongosh --port 27019  --quiet<<EOF
use somedb;
db.helloDoc.countDocuments();
EOF
