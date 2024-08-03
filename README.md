# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs


# Схема архитектуры

# Реализация

## Как запустить

Перейти в папку mongo-sharding

Запустить команду

```shell
docker compose up --build -d
```

Инициализация конфиг сервера:

```shell
docker exec -it configSrv mongosh --port 27020

> rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27020" }
    ]
  }
);
> exit();
```

Инициализация шардов:

```shell
docker exec -it shard1 mongosh --port 27021

> rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27021" },
        { _id : 1, host: "mongodb1:27017" },
        { _id : 2, host: "mongodb2:27018" }
      ]
    }
);
> exit();

docker exec -it shard2 mongosh --port 27022

> rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2:27022" },
        { _id : 1, host: "mongodb3:27019" },
        { _id : 2, host: "mongodb4:27016" }
      ]
    }
  );
> exit();
```

Инициализация роутера и наполнение тестовыми данными:

```shell
docker exec -it mongos_router mongosh --port 27023

> sh.addShard( "shard1/shard1:27021");
> sh.addShard( "shard2/shard2:27022");

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb

> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

> db.helloDoc.countDocuments() 
> exit(); 
```

Проверка данных на шардах:

```shell
 docker exec -it shard1 mongosh --port 27021
 > use somedb;
 > db.helloDoc.countDocuments();
 > exit(); 

 docker exec -it shard2 mongosh --port 27022
 > use somedb;
 > db.helloDoc.countDocuments();
 > exit(); 
```