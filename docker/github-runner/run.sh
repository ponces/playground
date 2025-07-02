#!/bin/bash
cd /work/actions-runner
REPO_TOKEN=$(curl -sfSL \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_PAT" \
  https://api.github.com/repos/ponces/$REPO_NAME/actions/runners/registration-token | jq -r '.token')
./config.sh --unattended --replace --url https://github.com/$REPO_USER/$REPO_NAME --token $REPO_TOKEN
./run.sh
