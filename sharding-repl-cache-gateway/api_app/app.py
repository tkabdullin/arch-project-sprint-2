import uuid
from typing import Optional, List
import time
from fastapi import FastAPI, Body, HTTPException, status
from pydantic import ConfigDict, BaseModel, Field, EmailStr
from pydantic.functional_validators import BeforeValidator
from pymongo import errors
import motor.motor_asyncio

from fastapi_cache import FastAPICache
from fastapi_cache.backends.redis import RedisBackend
from fastapi_cache.decorator import cache
from redis import asyncio as aioredis
from logmiddleware import RouterLoggingMiddleware, logging_config

import os
import logging
import logging.config
import json
from typing_extensions import Annotated
from bson import ObjectId
import consul
import socket

# Configure JSON logging
logging.config.dictConfig(logging_config)
logger = logging.getLogger(__name__)

app = FastAPI()
app.add_middleware(
    RouterLoggingMiddleware,
    logger=logger,
)

DATABASE_URL = os.environ["MONGODB_URL"]
DATABASE_NAME = os.environ["MONGODB_DATABASE_NAME"]
REDIS_URL = os.getenv("REDIS_URL", None)
CONSUL_HOST = os.getenv("CONSUL_HOST", None)
CONSUL_PORT = os.getenv("CONSUL_PORT", None)
SERVICE_NAME = os.getenv("SERVICE_NAME", None)
SERVICE_PORT = os.getenv("SERVICE_PORT", None)
SERVICE_ID = f"{SERVICE_NAME}-{uuid.uuid4()}"


# DATABASE_URL = "mongodb://127.0.0.1/"
# DATABASE_NAME = "somedb"
# REDIS_URL = "redis://127.0.0.1:6379"
# CONSUL_HOST = "127.0.0.1"
# CONSUL_PORT = "8500"
# SERVICE_NAME = "pymongo-svc"
# SERVICE_PORT = 8000
# SERVICE_ID = f"{SERVICE_NAME}-{uuid.uuid4()}"
# REDIS_URL = ""


def register_service_with_consul():
    consul_client = consul.Consul(host=CONSUL_HOST, port=CONSUL_PORT)

    hostname = socket.gethostname()
    host_ip = socket.gethostbyname(hostname)

    consul_client.agent.service.register(
        name=SERVICE_NAME,
        service_id=SERVICE_ID,
        address=host_ip,
        port=int(SERVICE_PORT),
        check=consul.Check.tcp(host_ip, int(SERVICE_PORT), "10s")
    )


def deregister_service_with_consul():
    consul_client = consul.Consul(host=CONSUL_HOST, port=CONSUL_PORT)
    consul_client.agent.service.deregister(SERVICE_ID)


def nocache(*args, **kwargs):
    def decorator(func):
        return func

    return decorator


if REDIS_URL:
    cache = cache
else:
    cache = nocache

client = motor.motor_asyncio.AsyncIOMotorClient(DATABASE_URL)
db = client[DATABASE_NAME]

# Represents an ObjectId field in the database.
# It will be represented as a `str` on the model so that it can be serialized to JSON.
PyObjectId = Annotated[str, BeforeValidator(str)]


@app.on_event("startup")
async def startup():
    register_service_with_consul()
    if REDIS_URL:
        redis = aioredis.from_url(REDIS_URL, encoding="utf8", decode_responses=True)
        FastAPICache.init(RedisBackend(redis), prefix="api:cache")


@app.on_event("shutdown")
async def shutdown():
    deregister_service_with_consul()


class UserModel(BaseModel):
    """
    Container for a single user record.
    """
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    age: int = Field(...)
    name: str = Field(...)


class UserCollection(BaseModel):
    """
    A container holding a list of `UserModel` instances.
    """

    users: List[UserModel]


@app.get("/")
async def root():
    collection_names = await db.list_collection_names()
    collections = {}
    for collection_name in collection_names:
        collection = db.get_collection(collection_name)
        collections[collection_name] = {"documents_count": await collection.count_documents({})}
    try:
        replica_status = await client.admin.command('replSetGetStatus')
        replica_status = json.dumps(replica_status, indent=2, default=str)
    except errors.OperationFailure:
        replica_status = "No Replicas"

    topology_description = client.topology_description
    read_preference = client.client_options.read_preference
    topology_type = topology_description.topology_type_name
    replicaset_name = topology_description.replica_set_name

    shards = None
    if topology_type == "Sharded":
        shards_list = await client.admin.command('listShards')
        shards = {}
        for shard in shards_list.get('shards', {}):
            shards[shard["_id"]] = shard["host"]

    cache_enabled = False
    if REDIS_URL:
        cache_enabled = FastAPICache.get_enable()

    return {
        "mongo_topology_type": topology_type,
        "mongo_replicaset_name": replicaset_name,
        "mongo_db": DATABASE_NAME,
        "read_preference": str(read_preference),
        "mongo_nodes": client.nodes,
        "mongo_primary_host": client.primary,
        "mongo_secondary_hosts": client.secondaries,
        "mongo_address": client.address,
        "mongo_is_primary": client.is_primary,
        "mongo_is_mongos": client.is_mongos,
        "collections": collections,
        "shards": shards,
        "cache_enabled": cache_enabled,
        "status": "OK",
    }


@app.get("/health")
async def health():
    return {"status": "OK"}


@app.get("/{collection_name}/count")
async def collection_count(collection_name: str):
    collection = db.get_collection(collection_name)
    items_count = await collection.count_documents({})
    # status = await client.admin.command('replSetGetStatus')
    # import ipdb; ipdb.set_trace()
    return {"status": "OK",
            "mongo_db": DATABASE_NAME,
            "items_count": items_count}


@app.get(
    "/{collection_name}/users",
    response_description="List all users",
    response_model=UserCollection,
    response_model_by_alias=False,
)
@cache(expire=60 * 1)
async def list_users(collection_name: str):
    """
    List all of the user data in the database.
    The response is unpaginated and limited to 1000 results.
    """
    time.sleep(1)
    collection = db.get_collection(collection_name)
    return UserCollection(users=await collection.find().to_list(1000))


@app.get(
    "/{collection_name}/users/{name}",
    response_description="Get a single user",
    response_model=UserModel,
    response_model_by_alias=False,
)
async def show_user(collection_name: str, name: str):
    """
    Get the record for a specific user, looked up by `name`.
    """

    collection = db.get_collection(collection_name)
    if (
            user := await collection.find_one({"name": name})
    ) is not None:
        return user

    raise HTTPException(status_code=404, detail=f"User {name} not found")


@app.post(
    "/{collection_name}/users",
    response_description="Add new user",
    response_model=UserModel,
    status_code=status.HTTP_201_CREATED,
    response_model_by_alias=False,
)
async def create_user(collection_name: str, user: UserModel = Body(...)):
    """
    Insert a new user record.

    A unique `id` will be created and provided in the response.
    """
    collection = db.get_collection(collection_name)
    new_user = await collection.insert_one(
        user.model_dump(by_alias=True, exclude=["id"])
    )
    created_user = await collection.find_one(
        {"_id": new_user.inserted_id}
    )
    return created_user


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
