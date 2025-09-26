#!/bin/bash

# Script to generate GPG key for APT repository signing
# This script helps create the GPG key needed for signing APT packages

set -e

echo "=== GPG Key Generation for APT Repository ==="
echo ""

# Check if GPG is installed
if ! command -v gpg &> /dev/null; then
    echo "Error: GPG is not installed. Please install it first."
    echo "On Ubuntu/Debian: sudo apt-get install gnupg2"
    echo "On macOS: brew install gnupg"
    exit 1
fi

# Get user input
read -p "Enter your name: " USER_NAME
read -p "Enter your email: " USER_EMAIL
read -p "Enter key comment (e.g., 'DragonflyDB APT Repository'): " KEY_COMMENT

# Generate a strong passphrase suggestion
echo ""
echo "Generating a random passphrase suggestion..."
SUGGESTED_PASSPHRASE=$(openssl rand -base64 32 | head -c 24)
echo "Suggested passphrase: $SUGGESTED_PASSPHRASE"
echo ""
read -s -p "Enter passphrase for the key (or use suggested): " PASSPHRASE
echo ""

# Create GPG batch file for key generation
cat > /tmp/gpg-batch << EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $USER_NAME
Name-Comment: $KEY_COMMENT
Name-Email: $USER_EMAIL
Expire-Date: 2y
Passphrase: $PASSPHRASE
%commit
%echo done
EOF

echo "Generating GPG key... (this may take a few minutes)"
gpg --batch --generate-key /tmp/gpg-batch

# Clean up batch file
rm /tmp/gpg-batch

# Get the key ID
KEY_ID=$(gpg --list-secret-keys --with-colons | grep sec | head -1 | cut -d: -f5)
KEY_FINGERPRINT=$(gpg --list-secret-keys --with-colons | grep fpr | head -1 | cut -d: -f10)

echo ""
echo "=== GPG Key Generated Successfully ==="
echo "Key ID: $KEY_ID"
echo "Fingerprint: $KEY_FINGERPRINT"
echo ""

# Export private key
echo "Exporting private key..."
gpg --batch --yes --pinentry-mode loopback --passphrase "$PASSPHRASE" \
    --armor --export-secret-keys $KEY_ID > dragonflydb-apt-private.key

# Export public key
echo "Exporting public key..."
gpg --armor --export $KEY_ID > dragonflydb-apt-public.key

echo ""
echo "=== GitHub Secrets Setup ==="
echo "You need to add the following secrets to your GitHub repository:"
echo ""
echo "1. GPG_PRIVATE_KEY:"
echo "   Copy the entire content of dragonflydb-apt-private.key"
echo ""
echo "2. GPG_KEY_ID:"
echo "   $KEY_ID"
echo ""
echo "3. GPG_PASSPHRASE:"
echo "   $PASSPHRASE"
echo ""
echo "=== Files Created ==="
echo "- dragonflydb-apt-private.key (keep this secure!)"
echo "- dragonflydb-apt-public.key (can be shared publicly)"
echo ""
echo "=== Security Notes ==="
echo "- Store the private key securely"
echo "- Add the private key content to GitHub Secrets"
echo "- Delete the local private key file after adding to GitHub Secrets"
echo "- The public key will be automatically published with your APT repository"
echo ""
echo "=== Next Steps ==="
echo "1. Go to your GitHub repository settings"
echo "2. Navigate to Secrets and variables > Actions"
echo "3. Add the three secrets mentioned above"
echo "4. Run the GitHub Action workflow"
echo ""

# Show the private key content for easy copying
echo "=== GPG_PRIVATE_KEY content (copy this to GitHub Secrets) ==="
cat dragonflydb-apt-private.key
echo ""
echo "=== End of GPG_PRIVATE_KEY content ==="
