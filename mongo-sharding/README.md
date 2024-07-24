# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Инициализация

```shell
docker exec -it configSrv mongosh --port 27017 --eval `
  "rs.initiate({ _id: 'config_server', configsvr: true, members: [{ _id: 0, host: 'configSrv:27017' }] });"
```

Инициализация шарды
```shell
docker exec -it shard1 mongosh --port 27018 --eval `
    "rs.initiate({ _id : 'shard1', members: [ { _id : 0, host : 'shard1:27018' }]})"
```
```shell
docker exec -it shard2 mongosh --port 27019 --eval `
    "rs.initiate({ _id : 'shard2', members: [{ _id : 1, host : 'shard2:27019' } ]})"
```


Инцициализация роутера и наполнение его тестовыми данными:
```shell

docker exec -i mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1:27018");
sh.addShard("shard2/shard2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name": "hashed" });

use somedb;

for (var i = 0; i < 1000; i++) {
    db.helloDoc.insert({ age: i, name: "ly" + i });
}

db.helloDoc.countDocuments();
EOF

```


Проверки на шардах
```shell

mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF


mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF


```

Открыть в браузере
```shell

http://localhost:8080

Open API http://localhost:8080/docs 

```


Open API
```shell

http://localhost:8080/docs 

```