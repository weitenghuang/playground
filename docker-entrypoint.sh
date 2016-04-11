#!/usr/bin/env ash

set -e

if [ "$NODE_ENV" == "development" ] && [ ! -d "/opt/playground/node_modules" ]; then
  echo "Installing dependencies >>>"
  npm install
fi

exec "$@"
