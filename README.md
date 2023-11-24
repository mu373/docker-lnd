# docker-lnd

Run [LND](https://github.com/lightningnetwork/lnd) on Docker.
- The base image is [lightninglabs/lnd](https://hub.docker.com/r/lightninglabs/lnd/tags).

## Prerequisites
- `bitcoind` running on a separate container
    - Use [mu373/docker-bitcoind](https://github.com/mu373/docker-bitcoind)
    - Container name: `bitcoind` (we access RPC using this hostname)
    - Docker network: `bitcoin-nw`
- [traefik proxy](https://doc.traefik.io/traefik/) running on a separate container
    - Use [mu373/traefik](https://github.com/mu373/traefik)
    - Docker network: `traefik-nw`

## Setup
Prepare configuration for `lnd`
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
$ lncli create
$ lncli unlock
```

See logs
```sh
docker logs --tail 100 container_id
```

## Accessing the node
- When the traefik is properly setup, you can access the LND REST API at `https://yourlndnode.example.com` at port 443.
- Some practical hints
    - Setup [Tailscale](https://tailscale.com/) in the host machine
    - Create `A` and `AAAA` record at `yourserver.example.com`, pointing to the host Tailscale IP
    - Create `CNAME` record at `yourlndnode.example.com`, pointing to `yourserver.example.com`
    - Tweak traefik proxy configs in `docker-compose.yml`
    - This way, you don't have to configure https and certificates within the LND container yourself. Traefik works as a reverse proxy and does all the complicated stuffs for you.

## References
- Options for `lnd.conf` is listed [here](https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf).
- `start-lnd.sh` comes from the [original repository](https://github.com/lightningnetwork/lnd/blob/master/docker/lnd/start-lnd.sh).
- Basic commands for `lncli`: [(link)](https://github.com/nayutaco/lightning-memo/blob/master/lnd.md#lncli)

## License
[MIT](https://github.com/mu373/docker-lnd/blob/main/LICENSE)
