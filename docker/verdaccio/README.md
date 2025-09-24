# verdaccio

Install and run a lightweight private npm proxy registry built in Node.js.
More info [here](https://verdaccio.org/).

### Configure

```sh
# Generate a credentials file
docker run --rm httpd:2.4 htpasswd -nbB <user> <pass> > htpasswd
```

## Install
```sh
docker compose up --detach
```
