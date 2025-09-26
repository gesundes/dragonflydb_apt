# DragonflyDB APT Repository

An automated APT repository that periodically mirrors DragonflyDB's amd64 deb packages from their official GitHub releases.

## ⚠️ Important Notice

This is an **unofficial** repository that mirrors packages from the official DragonflyDB releases. For official support and packages, please visit:
- [DragonflyDB Official Repository](https://github.com/dragonflydb/dragonfly)
- [Official Releases](https://github.com/dragonflydb/dragonfly/releases)

## Features

- 🔄 Automatically syncs with DragonflyDB releases daily
- 📦 Maintains proper APT repository structure
- 🔐 GPG-signed packages for security
- 🌐 Hosted on GitHub Pages
- 📱 Manual trigger support via GitHub Actions

## Quick Start

### Adding the Repository

```bash
# Add GPG key
curl -fsSL https://gesundes.github.io/dragonflydb_apt/pubkey.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/dragonflydb.gpg

# Add repository
echo "deb [signed-by=/etc/apt/keyrings/dragonflydb.gpg] https://gesundes.github.io/dragonflydb_apt stable main" | sudo tee /etc/apt/sources.list.d/dragonflydb.list >/dev/null

# Update package list
sudo apt update

# Install DragonflyDB
sudo apt install dragonfly
```

### Installing DragonflyDB

Once the repository is added:

```bash
# Install the latest version
sudo apt install dragonfly

# Install a specific version (if available)
sudo apt install dragonfly=1.0.0

# List available versions
apt list -a dragonfly
```

## Setup Instructions

### Prerequisites

- GitHub repository with Actions enabled
- GitHub Pages enabled for the repository

### 1. Generate GPG Keys

Run the provided script to generate GPG keys for package signing:

```bash
./scripts/generate-gpg-key.sh
```

This will generate:
- `dragonflydb-apt-private.key` (keep secure!)
- `dragonflydb-apt-public.key` (can be shared)

### 2. Configure GitHub Secrets

Go to your repository settings → Secrets and variables → Actions, and add:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `GPG_PRIVATE_KEY` | Complete private key content | `-----BEGIN PGP PRIVATE KEY BLOCK-----...` |
| `GPG_KEY_ID` | GPG key ID (8-character hex) | `ABCD1234` |
| `GPG_PASSPHRASE` | Passphrase for the private key | `your-secure-passphrase` |

### 3. Enable GitHub Pages

1. Go to Settings → Pages
2. Source: GitHub Actions
3. The workflow will automatically deploy to Pages

### 4. Run the Workflow

The workflow runs automatically daily at 6 AM UTC, or you can trigger it manually:

1. Go to Actions tab
2. Select "Update APT Repository"
3. Click "Run workflow"

## Repository Structure

```
├── .github/
│   └── workflows/
│       └── update-apt-repo.yml    # Main GitHub Actions workflow
├── apt-repo/                      # APT repository files (auto-generated)
│   ├── dists/
│   │   └── stable/
│   │       └── main/
│   │           └── binary-amd64/
│   │               ├── Packages
│   │               └── Packages.gz
│   ├── pool/
│   │   └── main/                  # .deb packages stored here
│   ├── pubkey.gpg                 # Public GPG key
│   └── index.html                 # Repository homepage
├── scripts/
│   └── generate-gpg-key.sh        # GPG key generation helper
└── README.md
```

## How It Works

1. **Scheduled Execution**: GitHub Actions runs daily at 6 AM UTC
2. **Release Fetching**: Queries DragonflyDB's GitHub API for releases
3. **Package Download**: Downloads new amd64 .deb packages to `pool/main/`
4. **Repository Generation**: Creates proper APT repository structure:
   - Generates `Packages` file using `dpkg-scanpackages`
   - Creates `Release` file with metadata and checksums
   - Signs files with GPG
5. **Deployment**: Publishes to GitHub Pages if changes are detected

## Workflow Features

### Automatic Updates
- Runs daily to check for new releases
- Only downloads packages that aren't already present
- Commits changes only if new packages are found

### Security
- GPG signs all repository metadata
- Uses secure secrets management
- Validates package integrity

### Efficiency
- Skips downloads for existing packages
- Only deploys when changes are detected
- Provides detailed summaries

## Manual Operations

### Force Update
Trigger the workflow manually via GitHub Actions interface or:

```bash
# Using GitHub CLI
gh workflow run "Update APT Repository"
```

### Local Testing
You can test the package download logic locally:

```bash
# Test package fetching
curl -s "https://api.github.com/repos/dragonflydb/dragonfly/releases" | \
jq -r '.[] | select(.draft == false and .prerelease == false) | .assets[] | select(.name | test(".*amd64.*\\.deb$")) | .browser_download_url'
```

## Troubleshooting

### Common Issues

**GPG Key Issues**
- Ensure all three GPG secrets are correctly set
- Verify the private key includes the full content with headers/footers
- Check that the key ID matches your generated key

**Permission Issues**
- Ensure the repository has Actions enabled
- Verify GitHub Pages is configured to use GitHub Actions
- Check that the workflow has necessary permissions

**Package Download Issues**
- Verify internet connectivity in Actions
- Check if DragonflyDB release API structure has changed
- Review API rate limits

### Debug Steps

1. Check the Actions log for detailed error messages
2. Verify GPG key setup by running the generation script
3. Test API endpoints manually
4. Check GitHub Pages deployment status

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally if possible
5. Submit a pull request

## Security Considerations

- Private GPG key is stored securely in GitHub Secrets
- Private key files are protected by .gitignore and never committed to git
- Repository metadata is cryptographically signed
- Users can verify package integrity using the public key
- Regular updates ensure latest security patches

## License

This repository configuration is provided as-is for educational and convenience purposes. DragonflyDB packages maintain their original licenses.

## Disclaimer

This is an unofficial mirror. Always verify packages against official sources for production use. The maintainers of this repository are not affiliated with the DragonflyDB project.
