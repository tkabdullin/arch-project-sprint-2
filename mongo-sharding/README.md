# mongo-sharding

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Конфигурируем шарды и заполняем mongodb данными

```shell
./scripts/sharding-init.sh
```

Проверка shard-1 на количество документов

```shell
./scripts/shard-1-check-count.sh
```

Проверка shard-2 на количество документов

```shell
./scripts/shard-2-check-count.sh
```

После проверки необходимо удалить контейнеры, сеть и тома

```shell
docker compose down -v
```
