# linux

Install and run a Linux virtual machine inside a Docker container.
More info [here](https://github.com/qemus/qemu).

### Configure

```sh
# Create a custom environment file based on the given template
cp .env.template .env
cat .env
# LINUX_PASSWORD=

# Generate a credentials string
docker run --rm httpd:2.4 htpasswd -nbB <user> <pass> | sed -e 's/\$/\$\$/g'
```

## Install
```sh
docker compose up --detach
```
