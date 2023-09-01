# localtunnel-server

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-zenjoy%2Flocaltunnel-lightgrey?style=flat)](https://hub.docker.com/r/zenjoy/localtunnel)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/zenjoy/localtunnel-server?label=version)](https://github.com/zenjoy/localtunnel-server/tags)
[![License](https://img.shields.io/github/license/zenjoy/docker-postgres-createdb)](https://github.com/zenjoy/localtunnel-server/blob/main/LICENSE)

localtunnel exposes your localhost to the world for easy testing and sharing! No need to mess with
DNS or deploy just to have others test out your changes.

This repo is the server component. If you are just looking for the CLI localtunnel app, see
(https://github.com/localtunnel/localtunnel).

## overview

The default localtunnel client connects to the `localtunnel.me` server. You can, however, easily set
up and run your own server. In order to run your own localtunnel server you must ensure that your
server can meet the following requirements:

- You can set up DNS entries for your `domain.tld` and `*.domain.tld` (or `sub.domain.tld` and
  `*.sub.domain.tld`).
- The server can accept incoming TCP connections for any non-root TCP port (i.e. ports over 1000).

The above are important as the client will ask the server for a subdomain under a particular domain.
The server will listen on any OS-assigned TCP port for client connections.

#### setup

```shell
# pick a place where the files will live
git clone git://github.com/zenjoy/localtunnel-server.git
cd localtunnel-server
yarn install

# server set to run on port 1234
bin/server --port 1234
```

The localtunnel server is now running and waiting for client requests on port 1234. You will most
likely want to set up a reverse proxy to listen on port 80 (or start localtunnel on port 80
directly).

**NOTE** By default, localtunnel will use subdomains for clients, if you plan to host your
localtunnel server itself on a subdomain you will need to use the _--domain_ option and specify the
domain name behind which you are hosting localtunnel. (i.e. my-localtunnel-server.example.com)

#### use your server

You can now use your domain with the `--host` flag for the `lt` client.

```shell
lt --host http://sub.example.tld:1234 --port 9000
```

You will be assigned a URL similar to `heavy-puma-9.sub.example.com:1234`.

If your server is acting as a reverse proxy (i.e. nginx) and is able to listen on port 80, then you
do not need the `:1234` part of the hostname for the `lt` client.

## REST API

### POST /api/tunnels

Create a new tunnel. A LocalTunnel client posts to this enpoint to request a new tunnel with a
specific name or a randomly assigned name.

### GET /api/status

General server information.

## Deploy

You can deploy your own localtunnel server using the prebuilt docker image.

**Note** This assumes that you have a proxy in front of the server to handle the http(s) requests
and forward them to the localtunnel server on port 3000. You can use our
[localtunnel-nginx](https://github.com/localtunnel/nginx) to accomplish this.

If you do not want ssl support for your own tunnel (not recommended), then you can just run the
below with `--port 80` instead.

```
docker run -d \
    --restart always \
    --name localtunnel \
    --net host \
    zenjoy/localtunnel-server:latest --port 3000
```

#### Authentication

You can enable authentication by setting the `AUTH_TOKEN` environment variable in the server. This
will require clients to pass the token as a query parameter to the server.

You can use the localtunnel-zenjoy package that added support for authentication.

```
npm install -g localtunnel-zenjoy
lt --host http://sub.example.tld:1234 --port 9000 --auth mytoken

export LOCALTUNNEL_AUTH_TOKEN=....
lt --host http://sub.example.tld:1234 --port 9000
```

## Docker Images

Available on Docker Hub or GitHub Container Registry (GHCR) for AMD64 or ARM64.

```sh
# Docker Hub
docker pull zenjoy/localtunnel:latest

# GHCR
docker pull ghcr.io/zenjoy/localtunnel:latest
```

## Container signatures

All images are automatically signed via [Cosign](https://docs.sigstore.dev/cosign/overview/) using
[keyless signatures](https://docs.sigstore.dev/cosign/keyless/). You verify the integrity of these
images as follows:

```sh
cosign verify \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity-regexp https://github.com/zenjoy/localtunnel-server/.github/workflows/ \
  zenjoy/localtunnel:latest
```

## Contributing

Feel free to contribute and make things better by opening an
[Issue](https://github.com/zenjoy/localtunnel-server/issues) or
[Pull Request](https://github.com/zenjoy/localtunnel-server/pulls).

## License

View [license information](https://github.com/zenjoy/localtunnel-server/blob/main/LICENSE) for the
software contained in this image.

## Acknowledgements

This project is a fork of the original [localtunnel/server](https://github.com/localtunnel/server)
project. This fork is intended to keep the project alive and maintained.
