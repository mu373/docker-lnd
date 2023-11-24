# docker-lnd

Run lnd tor on Docker.
- The base image is [lightninglabs/lnd](https://hub.docker.com/r/lightninglabs/lnd/tags).
- You need `bitcoind` running on a separate container
    - Use [mu373/docker-bitcoind](https://github.com/mu373/docker-bitcoind)

## Setup
Prepare configuration for `bitcoind`
```sh
cp docker-compose-template.yml docker-compose.yml
cp lnd/lnd.sample.conf lnd/lnd.conf
vim lnd/lnd.conf # Edit the configuration to fit your needs
```

Start the container
```sh
docker compose up -d
```

Access the shell inside the container
```sh
# In host
docker ps # Check container id
docker exec -it container_id bash

# In the container
$ lncli getinfo
```

See logs
```sh
docker logs --tail 100 container_id
```

