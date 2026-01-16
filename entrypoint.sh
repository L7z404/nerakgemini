#!/bin/bash
# Entrypoint script for Phoenix development container
# This runs before the main CMD and ensures dependencies are installed

# Exit immediately if any command fails
set -e

# Install Hex package manager (if not already installed)
# --force flag skips confirmation prompts
mix local.hex --force

# Install Rebar3 build tool (if not already installed)
# Required for building some Erlang dependencies
mix local.rebar --force

# Fetch and compile all Mix dependencies
# This runs against the volume-mounted deps directory
# so dependencies persist between container restarts
mix deps.get

# Execute the CMD passed to the container (e.g., "mix phx.server")
# exec replaces the shell process with the command, ensuring proper signal handling
exec "$@"
