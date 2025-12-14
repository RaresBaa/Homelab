#!/bin/bash

DUCKDNS_DOMAIN=""
DUCKDNS_TOKEN=""
IP_FILE="/tmp/current_ip_duckdns"

# Get current WAN IP using upnpc
WAN_IP=$(upnpc -s | grep "ExternalIPAddress" | awk '{print $3}')

if [[ -z "$WAN_IP" ]]; then
  echo "$(date) - Failed to fetch WAN IP"
  exit 1
fi

# Check if the IP has changed
if [[ -f "$IP_FILE" && "$(cat "$IP_FILE")" == "$WAN_IP" ]]; then
  echo "$(date) - WAN IP has not changed. No update needed."
  exit 0
fi

# Update DuckDNS record
RESPONSE=$(curl -s "https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip=$WAN_IP")

if [[ "$RESPONSE" == "OK" ]]; then
  echo "$(date) - Successfully updated DuckDNS with IP: $WAN_IP"
  echo "$WAN_IP" > "$IP_FILE"  # Save the new IP to file
else
  echo "$(date) - Failed to update DuckDNS. Response: $RESPONSE"
  exit 1
fi
