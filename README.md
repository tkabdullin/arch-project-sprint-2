Спринт 2, задания 1-6

Схема в корне проекта:
spint_2.drawio

Проверка:
перейти в директорию sharding-repl-cache и запустить:
docker compose up -d

Дождаться пока пропадет из активных контейнер mongosetup (примерно 30 сек).
Проверить можно с помощью команды:
docker ps --filter name=mongosetup

Проверка данных на шардах:
docker exec -it shard1-1 mongosh "mongodb://localhost:27011/somedb" --eval 'db.helloDoc.countDocuments();'
docker exec -it shard2-1 mongosh "mongodb://localhost:27021/somedb" --eval 'db.helloDoc.countDocuments();'
