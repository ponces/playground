# windows

Install and run a Windows virtual machine inside a Docker container.
More info [here](https://github.com/dockur/windows).

### Configure

```sh
# Create a custom environment file based on the given template
cp .env.template .env
cat .env
# WINDOWS_PASSWORD=
```

## Install
```sh
docker compose up --detach
```
