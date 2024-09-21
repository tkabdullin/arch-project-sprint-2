Инструкция по развертыванию:

  Переход в директорию и запуск контейнеров:
    cd mongo-sharding
    docker-compose up -d

  Конфигурация сервера конфигурации, шардов и роутера:
    docker-compose exec configSrv sh -c "mongosh < /scripts/init-configserver.js"
    docker-compose exec shard1 sh -c "mongosh shard1:27018 < /scripts/init-shard1.js"
    docker-compose exec shard2 sh -c "mongosh shard2:27019 < /scripts/init-shard2.js"
    docker-compose exec mongos_router sh -c "mongosh mongos_router:27020 < /scripts/init-router.js"

  Заполнение тестовыми данными:
    sh ./scripts/mongo-init.sh

  Просмотр заполнения шардов:
    sh ./scripts/count-shard1.sh
    sh ./scripts/count-shard2.sh