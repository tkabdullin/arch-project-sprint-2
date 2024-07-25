
#!/bin/bash


docker compose exec -T mongos_router mongosh --port 27017 <<EOF
use somedb
for(var i = 0; i < 2000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
EOF
