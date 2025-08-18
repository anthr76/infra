#!/bin/bash

# VolSync rsync.net Setup Script
# This script helps set up SSH keys and Google Secret Manager secrets for VolSync with rsync.net

set -e

# Configuration - Update these values
RSYNC_NET_SERVER="your-account.rsync.net"  # e.g., zh1234.rsync.net
RSYNC_NET_USER="your-account"              # e.g., zh1234
PROJECT_ID="kutara-infra"                  # Your GCP project ID

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}VolSync rsync.net Setup Script${NC}"
echo "=========================================="

# Check if required tools are installed
command -v gcloud >/dev/null 2>&1 || { echo -e "${RED}Error: gcloud CLI is required but not installed.${NC}" >&2; exit 1; }
command -v ssh-keygen >/dev/null 2>&1 || { echo -e "${RED}Error: ssh-keygen is required but not installed.${NC}" >&2; exit 1; }
command -v ssh-keyscan >/dev/null 2>&1 || { echo -e "${RED}Error: ssh-keyscan is required but not installed.${NC}" >&2; exit 1; }

echo "✓ Required tools found"

# Verify configuration
echo ""
echo -e "${YELLOW}Please verify your configuration:${NC}"
echo "  rsync.net server: $RSYNC_NET_SERVER"
echo "  rsync.net user: $RSYNC_NET_USER"
echo "  GCP Project: $PROJECT_ID"
echo ""
read -p "Is this configuration correct? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please update the configuration in this script and run again."
    exit 1
fi

# Create temporary directory
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Generate SSH key pair
echo ""
echo -e "${GREEN}Step 1: Generating SSH key pair...${NC}"
ssh-keygen -t ed25519 -f "$TMP_DIR/volsync_rsync_net" -N "" -C "volsync-rsync-net-backup"
echo "✓ SSH key pair generated"

# Get the rsync.net host key
echo ""
echo -e "${GREEN}Step 2: Getting rsync.net host key...${NC}"
ssh-keyscan "$RSYNC_NET_SERVER" > "$TMP_DIR/host_key" 2>/dev/null
if [ -s "$TMP_DIR/host_key" ]; then
    echo "✓ Host key retrieved"
else
    echo -e "${RED}Failed to retrieve host key. Please check the server address.${NC}"
    exit 1
fi

# Create Google Secret Manager secrets
echo ""
echo -e "${GREEN}Step 3: Creating Google Secret Manager secrets...${NC}"

# Private key
echo "Creating private key secret..."
gcloud secrets create rsync-net-private-key \
    --project="$PROJECT_ID" \
    --data-file="$TMP_DIR/volsync_rsync_net" || \
    (echo "Updating existing private key secret..." && \
     gcloud secrets versions add rsync-net-private-key \
     --project="$PROJECT_ID" \
     --data-file="$TMP_DIR/volsync_rsync_net")

# Public key
echo "Creating public key secret..."
gcloud secrets create rsync-net-public-key \
    --project="$PROJECT_ID" \
    --data-file="$TMP_DIR/volsync_rsync_net.pub" || \
    (echo "Updating existing public key secret..." && \
     gcloud secrets versions add rsync-net-public-key \
     --project="$PROJECT_ID" \
     --data-file="$TMP_DIR/volsync_rsync_net.pub")

# Host key
echo "Creating host key secret..."
gcloud secrets create rsync-net-host-key \
    --project="$PROJECT_ID" \
    --data-file="$TMP_DIR/host_key" || \
    (echo "Updating existing host key secret..." && \
     gcloud secrets versions add rsync-net-host-key \
     --project="$PROJECT_ID" \
     --data-file="$TMP_DIR/host_key")

echo "✓ All secrets created in Google Secret Manager"

# Display next steps
echo ""
echo -e "${GREEN}Setup Complete!${NC}"
echo "=========================================="
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Add the following public key to your rsync.net account:"
echo "   (Copy the entire line below)"
echo ""
cat "$TMP_DIR/volsync_rsync_net.pub"
echo ""
echo "2. Log in to your rsync.net account and add the public key to ~/.ssh/authorized_keys"
echo ""
echo "3. Test the SSH connection:"
echo "   ssh -i $TMP_DIR/volsync_rsync_net $RSYNC_NET_USER@$RSYNC_NET_SERVER"
echo ""
echo "4. Update your VolSync ReplicationSource configurations with:"
echo "   - address: \"$RSYNC_NET_SERVER\""
echo "   - sshUser: \"$RSYNC_NET_USER\""
echo ""
echo -e "${YELLOW}Security Note:${NC}"
echo "The private key file will be automatically deleted when this script exits."
echo "However, please verify that no sensitive data remains in: $TMP_DIR"

# Clean up
trap "rm -rf $TMP_DIR" EXIT

echo ""
echo -e "${GREEN}Ready to use VolSync with rsync.net!${NC}"
