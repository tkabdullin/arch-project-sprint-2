#!/bin/bash

### Заполняем тестовыми данными

docker compose exec -T mongos_router mongosh --port 27021 --quiet <<EOF
use somedb
for(var i = 0; i < 10000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i, id:"test-id-"+i})
db.helloDoc.countDocuments()
exit();
EOF
