#!/bin/bash

###
# Колво документов
###

docker compose exec -T shard01-a mongosh --port 27101 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

