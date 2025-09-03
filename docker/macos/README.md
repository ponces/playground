# macos

Install and run a macOS virtual machine inside a Docker container.
More info [here](https://github.com/dockur/macos).

### Configure

```sh
# Create a custom environment file based on the given template
cp .env.template .env
cat .env
# MACOS_PASSWORD=
```

## Install
```sh
docker compose up --detach
```
