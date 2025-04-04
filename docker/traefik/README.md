# Traefik

Install and run an open source reverse proxy and ingress controller for your Docker services and APIs.
More info [here](https://doc.traefik.io/traefik/getting-started/quick-start/).

### Configure

```sh
# Create a custom environment file based on the given template
cp .env traefik.env
cat traefik.env
# BASIC_AUTH_USER=
# BASIC_AUTH_PASS=

# Generate a credentials string
apt install -y apache2-utils
echo $(htpasswd -nb <user> <pass>) | sed -e s/\\$/\\$\\$/g
```

## Install
```sh
docker compose --env-file traefik.env up --detach
```
