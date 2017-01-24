DOCKER_MACHINE_NAME=concourse-dev
CONCOURSE_EXTERNAL_URL=127.0.0.1
FLY_OS=darwin
FLY_ARCH=amd64
FLY_VERSION=v2.6.0
FLY_BINARY_URL=https://github.com/concourse/concourse/releases/download/$(FLY_VERSION)/fly_$(FLY_OS)_$(FLY_ARCH)
FLY_BIN=bin/fly

bootstrap:
	mkdir -p keys/web keys/worker

	ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
	ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''

	ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''

	cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
	cp ./keys/web/tsa_host_key.pub ./keys/worker


bin/fly:
	mkdir bin
	wget -o $(FLY_BIN) $(FLY_BINARY_URL)
	chmod +x $(FLY_BIN)

create-machine:
	we -a env-dev.yml docker-machine create -d digitalocean $(DOCKER_MACHINE_NAME)

delete-machine:
	we -a env-dev.yml docker-machine rm $(DOCKER_MACHINE_NAME)

run:
	we -a env-dev.yml docker-compose up

run-local-web:
	concourse web \
	    --basic-auth-username admin \
	    --basic-auth-password admin \
	    --session-signing-key keys/web/session_signing_key \
	    --tsa-host-key keys/web/tsa_host_key \
	    --tsa-authorized-keys keys/web/authorized_worker_keys \
	    --postgres-data-source 'postgres://concourse:changeme@localhost:5432/concourse?sslmode=disable' \
	    --external-url http://localhost

run-local-worker:
	mkdir -p local-workdir
	sudo concourse worker \
	  --work-dir `pwd`/local-workdir \
	  --tsa-host 127.0.0.1 \
	  --tsa-public-key keys/web/tsa_host_key.pub \
	  --tsa-worker-private-key keys/worker/worker_key
