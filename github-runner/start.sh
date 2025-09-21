#!/bin/bash
# Exit immediately if any command fails
set -e

# Validate if GH_URL is set, otherwise exit with an error
if [ -z "$GH_URL" ]; then
  echo 1>&2 "error: missing GH_URL environment variable"
  exit 1
fi

# Create the work directory if it is defined
if [ -n "$GH_WORK" ]; then
  mkdir -p "$GH_WORK"
fi


# Remove any existing runner installation and create a fresh directory
rm -rf /gh/agent
mkdir /gh/agent
cd /gh/agent

# Allow the runner to run as root
export RUNNER_ALLOW_RUNASROOT=1

# Function to print section headers in light cyan color
print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

print_header "1. Setting Github Runner URL..."

# Set GH_Runner Package URL
GH_RUNNERPACKAGE_URL="https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-arm64-2.328.0.tar.gz"

print_header "2. Downloading and installing Github Runner..."
echo "$GH_RUNNERPACKAGE_URL"

# Download and extract the runner package
curl -LsS $GH_RUNNERPACKAGE_URL | tar -xz & wait $!

# Source the environment variables from the runner package
source ./env.sh

print_header "3. Configuring Github Runner..."

# Run the runner configuration script in unattended mode
./config.sh --url "$GH_URL" \
  --token "$GH_TOKEN" \
  --runnergroup "$GH_RUNNERGROUP" \
  --name "$GH_AGENT_NAME" \
  --work "$GH_WORK" \
  --labels workflow-runner-self-hosted \
  --replace \
  --unattended & wait $!

print_header "4. Running Github Runner..."

# Execute runner run script
./run.sh