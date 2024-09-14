# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Подключитесь к серверу конфигурации и сделайте инициализацию:
```shell
docker-compose exec  configSrv01 sh -c "mongosh --port 27017 < /scripts/init-configserver.js"
```

Инициализируйте шард1:
```shell
docker-compose exec  shard1 sh -c "mongosh --port 27018 < /scripts/init-shard1.js"
```

Инициализируйте шард2:
```shell
docker-compose exec  shard2 sh -c "mongosh --port 27019 < /scripts/init-shard2.js"
```

Инцициализируйте роутер:
```shell
docker-compose exec  mongos_router sh -c "mongosh --port 27020 < /scripts/init-router.js"
```

Инцициализируйте данными:
```shell
docker-compose exec  mongos_router sh -c "mongosh --port 27020 < /scripts/router-insertdata.js"
```


Инициализируем репликацию для шарда 1
```shell
docker-compose exec  shard1 sh -c "mongosh --port 27018 < /scripts/init-replica-shard1.js"
```

Инициализируем redis кластер

```shell
docker-compose exec  redis sh -c "echo "yes" | redis-cli --cluster create   redis:6379   redis2:6379   redis3:6379    redis4:6379  redis5:6379   redis6:6379   --cluster-replicas 1 redis-cli cluster nodes"
```


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