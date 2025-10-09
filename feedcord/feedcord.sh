#!/bin/bash

# --- Configuration ---
REPO_OWNER="homelabindia"
REPO_NAME="webapps"
FILE_PATH="feedcord/appsettings.json"  # Path to the file within the repository
LOCAL_DESTINATION="location_of_appsettings/appsettings.json" # <--- **CHANGE THIS!**
LOG_FILE="/var/log/git_pull_appsettings_feedcord.log"
DOCKER_COMPOSE_FILE="location_of_feedcord_docker_compose/docker-compose.yaml" # <--- **CHANGE THIS!**

# --- Functions ---

log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# --- Main Script ---

log_message "Starting git pull of appsettings.json and restarting Feedcord."

# Construct the Git URL for the single file
GIT_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/${FILE_PATH}"

log_message "Downloading ${FILE_PATH} from ${GIT_URL}."

# Download the file using wget
wget -E --no-cache -q "$GIT_URL" -O "$LOCAL_DESTINATION"

if [ $? -ne 0 ]; then
  log_message "ERROR: Failed to download ${FILE_PATH} from GitHub. Check the URL and your internet connection."
  exit 1
fi

#inserting discord webhook
sed -i 's|discord-webhook|replace_with_discord_webhook|' /home/gtzapper/docker/feedcord/appsettings.json


log_message "Bringing down Docker Compose containers..."
docker compose -f "$DOCKER_COMPOSE_FILE" down

if [ $? -ne 0 ]; then
  log_message "ERROR: Failed to bring down Docker Compose containers."
  exit 1
fi

log_message "Bringing up Docker Compose containers..."
docker compose -f "$DOCKER_COMPOSE_FILE" up -d

if [ $? -ne 0 ]; then
  log_message "ERROR: Failed to bring up Docker Compose containers."
  exit 1
fi

log_message "Git pull and Docker rebuild completed successfully."

exit 0
