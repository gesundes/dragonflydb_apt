# Setup Guide: Adding GitHub Secrets for DragonflyDB APT Repository

This guide walks you through the complete setup process for configuring GitHub secrets needed for the automated APT repository.

## Prerequisites

- GitHub repository with this code
- Local terminal access
- GPG installed on your system

## Step 1: Generate GPG Keys

### 1.1 Run the GPG Key Generation Script

```bash
# Make the script executable
chmod +x scripts/generate-gpg-key.sh

# Run the script
./scripts/generate-gpg-key.sh
```

### 1.2 Follow the Interactive Prompts

The script will ask for:
- **Your name**: Enter your full name (e.g., "John Doe")
- **Your email**: Enter your email address
- **Key comment**: Enter something like "DragonflyDB APT Repository"
- **Passphrase**: Use the suggested secure passphrase or create your own

### 1.3 Note the Output

After generation, the script will display:
```
Key ID: ABCD1234
Fingerprint: 1234567890ABCDEF1234567890ABCDEF12345678
```

**Important**: Save these values - you'll need them for GitHub secrets!

## Step 2: Locate Generated Files

The script creates two files:
- `dragonflydb-apt-private.key` - **Keep this secure!**
- `dragonflydb-apt-public.key` - Can be shared publicly

## Step 3: Add GitHub Secrets

### Method A: Using GitHub Web Interface (Recommended)

#### 3.1 Navigate to Repository Settings
1. Go to your GitHub repository
2. Click **Settings** (in the repository's top navigation)
3. In the left sidebar: **Secrets and variables** → **Actions**

#### 3.2 Add Secret #1: GPG_PRIVATE_KEY
1. Click **New repository secret**
2. **Name**: `GPG_PRIVATE_KEY`
3. **Secret**: Copy the entire content of `dragonflydb-apt-private.key`
   ```
   # Open the file and copy ALL content including headers
   cat dragonflydb-apt-private.key
   ```
   The content should start with `-----BEGIN PGP PRIVATE KEY BLOCK-----` and end with `-----END PGP PRIVATE KEY BLOCK-----`
4. Click **Add secret**

#### 3.3 Add Secret #2: GPG_KEY_ID
1. Click **New repository secret**
2. **Name**: `GPG_KEY_ID`
3. **Secret**: Enter the Key ID from Step 1.3 (e.g., `ABCD1234`)
4. Click **Add secret**

#### 3.4 Add Secret #3: GPG_PASSPHRASE
1. Click **New repository secret**
2. **Name**: `GPG_PASSPHRASE`
3. **Secret**: Enter the passphrase you used when generating the key
4. Click **Add secret**

### Method B: Using GitHub CLI

If you have [GitHub CLI](https://cli.github.com/) installed:

```bash
# Install GitHub CLI first if needed:
# - macOS: brew install gh
# - Ubuntu: sudo apt install gh
# - Windows: winget install GitHub.CLI

# Authenticate with GitHub
gh auth login

# Navigate to your repository directory
cd /path/to/your/dragonflydb_repo

# Set the secrets
gh secret set GPG_PRIVATE_KEY < dragonflydb-apt-private.key
echo "ABCD1234" | gh secret set GPG_KEY_ID  # Replace with your actual key ID
echo "your-passphrase" | gh secret set GPG_PASSPHRASE  # Replace with your passphrase
```

## Step 4: Enable GitHub Pages

### 4.1 Configure Pages Settings
1. In your repository, go to **Settings**
2. Scroll to **Pages** (in left sidebar)
3. Under **Source**, select **GitHub Actions**
4. Click **Save**

### 4.2 Verify Configuration
You should see: "Your site is ready to be published at `https://YOUR-USERNAME.github.io/YOUR-REPO-NAME/`"

## Step 5: Test the Setup

### 5.1 Manually Trigger the Workflow
1. Go to **Actions** tab in your repository
2. Click **Update APT Repository** workflow
3. Click **Run workflow** button
4. Select the branch (usually `main` or `master`)
5. Click **Run workflow**

### 5.2 Monitor the Execution
- Watch the workflow run in real-time
- Check for any errors in the logs
- Verify that packages are downloaded successfully

### 5.3 Verify Repository Creation
After successful completion, check:
- Your repository URL: `https://YOUR-USERNAME.github.io/YOUR-REPO-NAME/`
- The `apt-repo/` directory should contain:
  - `dists/stable/main/binary-amd64/Packages`
  - `dists/stable/Release`
  - `pool/main/*.deb` files
  - `pubkey.gpg`

## Step 6: Clean Up Local Files

### 6.1 Secure the Private Key
After adding to GitHub secrets:
```bash
# Securely delete the private key file
shred -vfz -n 3 dragonflydb-apt-private.key
# Or on macOS:
rm -P dragonflydb-apt-private.key
```

### 6.2 Keep the Public Key (Optional)
The public key file can be kept or deleted - it will be regenerated automatically.

## Step 7: Update Repository URLs

### 7.1 Update README.md
Replace placeholders in `README.md`:
- `YOUR-USERNAME` → Your GitHub username
- `YOUR-REPO-NAME` → Your repository name

### 7.2 Update index.html
Replace the same placeholders in `apt-repo/index.html`

## Troubleshooting

### Common Issues

#### "GPG Key Not Found" Error
**Problem**: GitHub Actions can't find your GPG key
**Solution**: 
- Verify the `GPG_KEY_ID` secret matches the output from step 1.3
- Ensure the private key includes the complete content with headers/footers

#### "Invalid Passphrase" Error
**Problem**: GPG operations fail during signing
**Solution**:
- Double-check the `GPG_PASSPHRASE` secret
- Ensure no extra spaces or characters

#### "Permission Denied" for GitHub Pages
**Problem**: Workflow can't deploy to Pages
**Solution**:
- Verify Pages is enabled with "GitHub Actions" as source
- Check repository permissions in Settings → Actions → General

#### No Packages Downloaded
**Problem**: Workflow runs but no packages are found
**Solution**:
- Check if DragonflyDB has released any .deb packages
- Verify API access to GitHub (rate limits)
- Review workflow logs for specific errors

### Getting Help

1. Check workflow logs in the Actions tab
2. Review error messages carefully
3. Verify all three secrets are correctly set
4. Test GPG key generation locally

### Verification Commands

To verify your setup locally:

```bash
# Test GPG key
gpg --list-secret-keys

# Test GitHub API access
curl -s "https://api.github.com/repos/dragonflydb/dragonfly/releases" | jq '.[0].name'

# Verify secrets are set (using GitHub CLI)
gh secret list
```

## Security Notes

- **Never commit private keys to git**
- **Use strong passphrases**
- **Regularly rotate GPG keys** (every 1-2 years)
- **Monitor repository access logs**
- **Keep GitHub secrets minimal** (only what's needed)

## Next Steps

After successful setup:
1. The repository will automatically sync daily at 6 AM UTC
2. Users can add your repository using the instructions in the generated website
3. Monitor GitHub Actions for any future failures
4. Consider setting up notifications for workflow failures

---

**Repository URL**: `https://YOUR-USERNAME.github.io/YOUR-REPO-NAME/`

For issues with this setup, create an issue in your repository using the provided issue template.