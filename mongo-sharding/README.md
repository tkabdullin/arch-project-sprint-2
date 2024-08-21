Запустить проект:
```
docker compose up
```

Инициализируем конфиг сервер:
```
docker exec -it configsvr mongosh --eval "rs.initiate({_id: 'configReplSet', configsvr: true, members: [{ _id: 0, host: 'configsvr:27019' }]})"
```

Инициализируем первый шард:
```
docker exec -it shard1 mongosh --eval "rs.initiate({_id: 'shard1ReplSet', members: [{ _id: 0, host: 'shard1:27018' }]})"
```

Инициализируем второй шард:
```
docker exec -it shard2 mongosh --eval "rs.initiate({_id: 'shard2ReplSet', members: [{ _id: 0, host: 'shard2:27020' }]})"
```

Добавляем шарды в роутер:
```
docker exec -it mongos mongosh --eval "sh.addShard('shard1ReplSet/shard1:27018')"
docker exec -it mongos mongosh --eval "sh.addShard('shard2ReplSet/shard2:27020')"
```

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