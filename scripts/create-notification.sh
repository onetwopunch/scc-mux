#!/usr/bin/env bash

# The description for the NotificationConfig
DESCRIPTION="Topic for team: $TEAM_NAME"

# Filters for active findings
FILTER="state=\"ACTIVE\" AND resource.project_display_name=\"$PROJECT\""
output=$(gcloud alpha scc notifications create $NOTIFICATION_NAME \
	--organization "$ORG_ID" \
	--description "$DESCRIPTION" \
	--pubsub-topic $PUBSUB_TOPIC \
	--filter "$FILTER" 2>&1)

if [ $? -ne 0 ]; then
	EXISTS_ERROR='Requested entity already exists'
	if echo $output | grep "$EXISTS_ERROR"; then
		echo "Skipping resource that already exists"
		exit 0
	else
		echo $output
		exit 1
	fi
fi
