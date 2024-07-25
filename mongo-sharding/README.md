# Номера портов

- **27017** The default port for mongod and mongos instances. You can change this port with port or --port.
- **27018** The default port for mongod when running with --shardsvr command-line option or the shardsvr value for the clusterRole setting in a configuration file.
- **27019** The default port for mongod when running with --configsvr command-line option or the configsvr value for the clusterRole setting in a configuration file.
- **27020** The default port from which mongocryptd listens for messages. mongocryptd is installed with MongoDB Enterprise Server and supports automatic encryption operations.


# Описание

Шардирование сделано по описанию из [офф документации](https://www.mongodb.com/docs/manual/tutorial/deploy-shard-cluster/#overview)

**Важный момент** - при конфигурировании инстансов через mongosh **необходимо** указывать порты на целевых машиных. Иначе, конфигурация не применяется.

## Конфиг сервер

Конфиг сервер запускается на 27019 порту и получает следующий конфиг из скрипта [config_init.sh](./config_init.sh):

```bash
rs.initiate(
  {
    _id: "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27019" },
    ]
  }
)
```

## Шарды

Всего создается 2 шарда, каждый на порту 27018 с помощью скрипта [init-shards.sh](./init-shards.sh), здесь приведу только один конфиг:
```bash
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
      ]
    }
);
```

## Роутер

Роутер запускается на порту 27017 с помощью скрипта [init-router.sh](./init-router.sh):
```bash
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
```

Из конфига видно, что задаются два шарда, затем включается шардирование для БД somedb и шардирование по хешу для коллекции helloDoc

## Наполнение данными

Для наполнения данными используется скрипт [fill_data.sh](./fill_data.sh):
```bash
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
```

## Проверка наполнения

Для проверки наполнения используется скрипт [count-data.sh](./count-data.sh) который подключается к каждому шарду и проверяет количество записей в коллекции (приведу только одно подключение):
```bash
use somedb;
db.helloDoc.countDocuments();
```
