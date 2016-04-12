#! /bin/bash

# This requires a secret-api-token.txt file.

docker run -it \
  -e LANG=en_US.UTF-8 \
  -e SLACK_API_TOKEN=$(cat secret-api-token.txt) \
  -v $(pwd):/source \
  images.reesd.com/reesd/stack:7.8.4 \
  sh -c '
  cabal install slack-api ;
  ghci -i/source /source/bin/superchaton.hs
  '
