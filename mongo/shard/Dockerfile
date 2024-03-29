FROM mongo:7.0

#ENV MONGO_INITDB_ROOT_USERNAME admin
#ENV MONGO_INITDB_ROOT_PASSWORD admin

COPY init-mongo-shard.js           /tmp/init-mongo-shard.js
ADD init-mongo-shard.sh            /docker-entrypoint-initdb.d/
