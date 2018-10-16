TARANTOOL_IMAGE="tnt"
TARANTOOL_NAME="tnt-msgpack-bug"
TARANTOOL_USER="tarantool"
TARANTOOL_PASSWORD="tarantool"
TARANTOOL_LISTEN="0.0.0.0:3302"

docker-build-tnt:
	docker build \
		-t ${TARANTOOL_IMAGE} \
		-f ./docker/tnt/Dockerfile \
		./tnt

docker-run-tnt: docker-build-tnt docker-remove-tnt
	docker run -d \
		--name ${TARANTOOL_NAME} \
		-p 3302:3302 \
		-e TARANTOOL_USER=${TARANTOOL_USER} \
		-e TARANTOOL_PASSWORD=${TARANTOOL_PASSWORD} \
		-e TARANTOOL_LISTEN=${TARANTOOL_LISTEN} \
		-e TARANTOOL_MEMTX_MEMMORY=104857600 \
		-e TARANTOOL_MEMTX_DIR=/var/lib/tarantool \
		-e TARANTOOL_WAL_DIR=/var/lib/tarantool \
		${TARANTOOL_IMAGE}

docker-entry-tnt:
	docker exec -it  ${TARANTOOL_NAME} /bin/sh

docker-remove-tnt:
	docker rm -f ${TARANTOOL_NAME} || true