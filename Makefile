CONCOURSE_EXTERNAL_URL=127.0.0.1


keys:
	mkdir -p keys/web keys/worker

keys/web/tsa_host_key.pub:
	ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''

keys/web/tsa_session_signing_key:
	ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''

keys/worker/worker_key.pub:
	ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''

keys/web/authorized_worker_keys: keys/worker/worker.pub
	cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys

keys/worker/tsa_host_key.pub: keys/web/tsa_host_key.pub
	cp ./keys/web/tsa_host_key.pub ./keys/worker


boostrap: keys

build:
	docker-compose build

run:
	$(eval CONCOURSE_EXTERNAL_URL?=127.0.0.1)
	docker-compose up
