#!/bin/bash

###
# Тест бд
###

docker compose exec -T shard1_master mongosh --port 27010 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard1_slave1 mongosh --port 27011 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard1_slave2 mongosh --port 27012 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF


docker compose exec -T shard2_master mongosh --port 27013 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard2_slave1 mongosh --port 27014 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard2_slave2 mongosh --port 27015 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF