#!/bin/bash
docker exec -i configSrv mongosh --port 27017 < configSrv-init.txt