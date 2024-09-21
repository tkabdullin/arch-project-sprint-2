docker stop $(docker ps -q)
docker rm $(docker ps -a -q)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q)
