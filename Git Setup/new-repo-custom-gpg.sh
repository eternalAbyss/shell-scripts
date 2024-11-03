#!/bin/bash

# Prompt the user for the necessary information
read -p "Enter your email: " user_email
read -p "Enter your name: " user_name
read -p "Enter your GPG signing key: " signing_key
read -p "Enter the repository URL: " repo_url

# Note: If you are running this script on macOS, you need to install the coreutils package to use the gtimeout command.
# You can install it using Homebrew with the following command:
# brew install coreutils

# Step 1 - Clone the repository
git clone $repo_url
echo "Moving into the repository directory"
cd $(basename $repo_url .git)

# Step 2 - Configure the repository
echo "Configuring the repository"

# Configuring the repository
git config --local user.email "$user_email"
git config --local user.name "$user_name"
git config --local user.signingkey "$signing_key"
git config --local commit.gpgsign true

# Step 3 - Verify configurations
echo "Verifying GPG signing"

# Test GPG signing
if echo "Testing GPG signing" | gtimeout 15s gpg --clearsign > /dev/null 2>&1; then
    echo "GPG signing test successful"
    echo "Moving out of the repository directory"
    cd ..
    echo "Repository setup complete"
else
    echo "GPG signing test failed"
    echo "Reverting back the changes"
    cd ..
    echo "Removing the repository"
    rm -rf $(basename $repo_url .git)
    echo "Repository removed"
    echo "Please try again"
fi

# End of script