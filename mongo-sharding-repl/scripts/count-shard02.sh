#!/bin/bash

###
# Колво документов
###

docker compose exec -T shard02-a mongosh --port 27201 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

