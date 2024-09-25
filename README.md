# Ссылка на основную диаграмму, покрывающую все задания в спринте 2
**ОБНОВЛЕННАЯ ССЫЛКА** на диаграммы для задания 1, 5 и 6 - https://app.diagrams.net/?title=sprint-2.drawio#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1sRBT4AENCEwSdlX1Q3DORSgAQfO343Q0%26export%3Ddownload

# Основная последовательность действий для запуска общенастроенного проекта для спринта 2

## Как запустить
**Все операции необходимо проводить в папке /sharding-repl-cache**

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Инициализируем config сервер

```shell
./scripts/configSrv-init.sh
```

Инициализируем шард №1

```shell
./scripts/shard1-init.sh
```
Инициализируем шард №2

```shell
./scripts/shard2-init.sh
```
Инициализируем роутер и наполняем данными

```shell
./scripts/mongos_router-init.sh
```

## Проверка через браузер

1. Открыть в браузере http://localhost:8080
2. В режиме инспекции сделать повторный запрос и изучить ответ в формате Preview
Количество шардов - 2
Количество реплик - 2
Количество документов - 1000
Кеш включен - true
![alt text](/sharding-repl-cache/repl-cache.png)

## Проверка через БД

### Шард 1
Выполнить скрипт для получения количества документов на шарде 1
```shell
./scripts/check-shard1.sh
```
Ответ должен вернуть 492

### Шард 2
Выполнить скрипт для получения количества документов на шарде 2
```shell
./scripts/check-shard2.sh
```
Ответ должен вернуть 508