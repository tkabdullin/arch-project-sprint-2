ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: config
config:
	@echo "Initializing app..."
	@bash ./scripts/config.sh
	@sleep 5
	@bash ./scripts/shard.sh
	@sleep 5
	@bash ./scripts/router.sh

.PHONY: start
start:
	@echo "Starting app..."
	@docker compose up -d --build

down:
	@echo "Stopping app..."
	@docker compose down

.PHONY: check_shard1
check_shards:
	@echo "Checking shard1 documents"
	@docker exec -it shard1 mongosh --port 27018 --eval "use somedb;" --eval "db.helloDoc.countDocuments();"
	@docker exec -it shard2 mongosh --port 27019 --eval "use somedb;" --eval "db.helloDoc.countDocuments();"

