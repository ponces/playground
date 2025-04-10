# Traefik

Install and run an open source reverse proxy and ingress controller for your Docker services and APIs.
More info [here](https://doc.traefik.io/traefik/getting-started/quick-start/).

### Configure

```sh
# Create a custom environment file based on the given template
cp .env.template .env
cat .env
# BASIC_AUTH_USER=
# BASIC_AUTH_PASS=

# Generate a credentials string
docker run --rm httpd:2.4 htpasswd -nbB <user> <pass> | sed -e 's/\$/\$\$/g'
```

## Install
```sh
docker network create web
```

```sh
docker compose up --detach
```
