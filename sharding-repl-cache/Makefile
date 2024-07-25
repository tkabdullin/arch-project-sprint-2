ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: config
config:
	@$(MAKE) init_config
	@sleep 5
	@$(MAKE) init_shards
	@sleep 5
	@$(MAKE) init_router

init_config:
	@echo "Config server"
	@docker compose exec configSrv sh -c "mongosh < /scripts/config.js"

init_shards:
	@echo "Config shards"
	@docker compose exec shard1-a sh -c "mongosh < /scripts/shard1.js"
	@docker compose exec shard2-a sh -c "mongosh < /scripts/shard2.js"

init_router:
	@echo "Config router"
	@docker compose exec mongos_router sh -c "mongosh --port 27020 < /scripts/router.js"


.PHONY: start
start:
	@echo "Starting app..."
	@docker compose up -d --build

stop:
	@echo "Stopping app..."
	@docker compose down -v

.PHONY: check_shard1
check_shards:
	@echo "Checking shard1 documents"
	@docker exec -it shard1-a mongosh --eval "use somedb;" --eval "db.helloDoc.countDocuments();"
	@docker exec -it shard2-a mongosh --eval "use somedb;" --eval "db.helloDoc.countDocuments();"

