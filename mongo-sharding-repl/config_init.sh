#!/bin/bash


docker compose exec -T configSrv mongosh --port 27019 <<EOF
rs.initiate(
  {
    _id: "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27019" },
    ]
  }
)
EOF
