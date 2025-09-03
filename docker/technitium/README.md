# technitium

Install and run an open source authoritative as well as recursive DNS server that can be used for self hosting a DNS server for privacy & security.
More info [here](https://technitium.com/dns/).

### Configure

```sh
# Create a custom environment file based on the given template
cp .env.template .env
cat .env
# DNS_SERVER_ADMIN_PASSWORD=

# Generate a credentials string
docker run --rm httpd:2.4 htpasswd -nbB <user> <pass> | sed -e 's/\$/\$\$/g'
```

## Install
```sh
docker compose up --detach
```
