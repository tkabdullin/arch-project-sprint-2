#!/bin/sh

docker compose exec -T shard1-0 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF