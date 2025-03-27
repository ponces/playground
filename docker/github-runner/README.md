# Github Runner

Install and run a selfhosted Github actions runnner using Docker.
More info [here](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners).

### Configure

```sh
cp .env <custom>.env
cat <custom>.env
# RUNNER_VERSION=2.323.0
# S6_OVERLAY_VERSION=3.2.0.2
# REPO_USER=...
# REPO_NAME=...
# GITHUB_PAT=...
```

## Install
```sh
docker compose up --detach
```
