# Concourse Playground

This repo is for getting a rough idea of how you can spin up a running
concourse instance for testing. The idea is that you can test jobs by
using a "dev" instance of concourse that can be created and destroyed
when you are happy with your CI code.

## How it works

There is a `Makefile` to help drive the different steps.

 - The `bootstrap` target creates some keys that the worker and web
   nodes will use.

 - The `bin/fly` target will help to instal `fly` cli to interact with
   concourse.

 - The `create|delete-machine` targets spin up a docker host in DO to
   run the services. This is necessary as the concourse web server
   needs an addressible IP outside the docker network in order to work
   correctly.

 - The `run` target runs docker compose and using the docker-machine
   info.

 - The `run-local-*` targets run the services locally. These assume
   the concourse executable has been installed and is available on
   your PATH.

## Using `we`

The repo uses `we` to make managing settings and configuration easy to
do in code. Most command line scripts accept environment variables for
values, which makes `we` a good option for codifying arguments in
declarative code (YAML), no matter what commands are used.

In the `Makefile` you'll see commands prefixed with the `we`
command. For example:

```
run:
	we -a env-dev.yml docker-compose up
```

The `we` command will read the `env-dev.yml` file and load up
environment variables accordingly. For documentation on how this
works, see the
docs [here](https://withenv.readthedocs.io/en/latest/).
