#!/usr/bin/env bash
set -euo pipefail
trap 'echo -e "${RED}[Go] Error on line $LINENO${NC}"' ERR

# Color definitions
BLUE='\033[0;34m'; BOLD_BLUE='\033[1;34m'
WHITE='\033[0;37m'; GREEN='\033[0;32m'
YELLOW='\033[0;33m'; RED='\033[0;31m'
NC='\033[0m'

header() {
  echo -e "${BLUE}───────────────────────────────────────────────${NC}"
  echo -e "${BOLD_BLUE}[Go] $1${NC}"
}

# Configurations
GO_RUN_CMD="${GO_RUN_CMD:-go run main.go}"
GO_PORT="${GO_PORT:-3000}"

export PORT="$GO_PORT"

header "Starting Go module"

# Change to container's Go app directory
cd /home/container/goapp || { echo -e "${RED}[Go] /home/container/goapp not found${NC}"; exit 1; }

# Ensure a tmp folder with enough space exists
mkdir -p /home/container/tmp

# Set Go environment variables to use it
export GOCACHE=/home/container/tmp/go-cache
export TMPDIR=/home/container/tmp
export GOPATH=/home/container/go

# Run the Go command
echo -e "${GREEN}[Go] Executing: ${GO_RUN_CMD}${NC}"
$GO_RUN_CMD
