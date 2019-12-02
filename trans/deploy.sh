#!/bin/bash

export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

source ./prod-env.sh

# Build Elixir Code
mix deps.get
mix compile

# Build Assets
mkdir -p priv/static
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

# Migrate DB
mix ecto.migrate

# Generate the release
mix release