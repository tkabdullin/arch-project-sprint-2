#!/bin/bash
docker compose exec -T mongos_router_repl mongosh --port 27020 <<EOF
use somedb
for(var i = 0; i < 3000; i++) db.helloDoc.insertOne({age:i, name:"sy"+i})
EOF
