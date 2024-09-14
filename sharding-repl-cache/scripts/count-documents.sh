#!/bin/bash

docker compose exec -T mongos_router mongosh --port 27020 --quiet  <<EOF

use somedb;
db.helloDoc.countDocuments();
exit();

EOF

docker compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1-2 mongosh --port 27016 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1-3 mongosh --port 27015 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2-1 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2-2 mongosh --port 27014 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2-3 mongosh --port 27013 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF