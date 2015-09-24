#!/bin/bash
docker --tls run \
  -e "GITHUB_OAUTH_TOKEN=$GITHUB_OAUTH_TOKEN" \
  -e "PINBOARD_API_KEY=$PINBOARD_API_KEY" \
  -e "S3_ID=$S3_ID" \
  -e "S3_SECRET=$S3_SECRET" \
  clifff/clifff.com
  jekyll server
