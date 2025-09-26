---
name: Repository Issue
about: Report problems with the APT repository
title: '[REPO] '
labels: ['bug', 'repository']
assignees: ''

---

## Issue Description
<!-- Provide a clear and concise description of the issue -->

## Issue Type
<!-- Check all that apply -->
- [ ] Package installation failure
- [ ] GPG signature verification error
- [ ] Repository sync/update issue
- [ ] Missing package versions
- [ ] GitHub Pages deployment problem
- [ ] Other (please specify)

## Environment Information
**Operating System:**
- [ ] Ubuntu 20.04 LTS
- [ ] Ubuntu 22.04 LTS
- [ ] Ubuntu 24.04 LTS
- [ ] Debian 11
- [ ] Debian 12
- [ ] Other: ___________

**Architecture:** 
- [ ] amd64
- [ ] Other: ___________

## Steps to Reproduce
<!-- Provide detailed steps to reproduce the issue -->
1. 
2. 
3. 

## Expected Behavior
<!-- Describe what you expected to happen -->

## Actual Behavior
<!-- Describe what actually happened -->

## Error Messages
<!-- Include any error messages or logs -->
```
Paste error messages here
```

## Command Output
<!-- Include the output of relevant commands -->

### APT Update Output:
```
sudo apt update
```

### Package Installation Output:
```
sudo apt install dragonfly
```

### GPG Key Verification:
```
gpg --verify /path/to/file
```

## Additional Context
<!-- Add any other context about the problem here -->

## Troubleshooting Steps Tried
<!-- Check all that you've already attempted -->
- [ ] Cleared APT cache (`sudo apt clean`)
- [ ] Updated package lists (`sudo apt update`)
- [ ] Re-added GPG key
- [ ] Re-added repository configuration
- [ ] Checked repository URL accessibility
- [ ] Verified internet connectivity
- [ ] Other: ___________

## Related Links
<!-- Include any relevant links -->
- Repository URL: https://YOUR-USERNAME.github.io/YOUR-REPO-NAME
- Specific package URL (if applicable): 
- GitHub Actions run (if applicable): 

---

**Note:** This is an unofficial repository. For official DragonflyDB support, please visit the [official repository](https://github.com/dragonflydb/dragonfly/issues).