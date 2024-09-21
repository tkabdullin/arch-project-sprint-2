Инструкция по развертыванию:

  Переход в директорию и запуск контейнеров:
    cd mongo-sharding-repl
    docker-compose up -d

  Конфигурация сервера конфигурации, шардов и роутера:
    docker-compose exec configSrv_repl sh -c "mongosh < /scripts/init-configserver.js"
    docker-compose exec shard01-a sh -c "mongosh shard01-a:27101 < /scripts/init-shard01.js"
    docker-compose exec shard02-a sh -c "mongosh shard02-a:27201 < /scripts/init-shard02.js"
    docker-compose exec mongos_router_repl sh -c "mongosh mongos_router_repl:27020 < /scripts/init-router.js"

  Заполнение тестовыми данными:
    sh ./scripts/mongo-init.sh

  Просмотр заполнения шардов:
    sh ./scripts/count-shard01.sh
    sh ./scripts/count-shard02.sh