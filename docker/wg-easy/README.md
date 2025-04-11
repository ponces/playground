# wg-easy

Install and run an WireGuard server with an easy to use and install Web UI.
More info [here](https://wg-easy.github.io/wg-easy/Pre-release/getting-started/).

### Configure

```sh
# Create a custom environment file based on the given template
cp .env.template .env
cat .env
# WG_EASY_PASSWORD=

# Generate a credentials string
docker run --rm httpd:2.4 htpasswd -nbB <pass> | sed -e 's/\$/\$\$/g'
```

## Install
```sh
docker compose up --detach
```
