#!/usr/bin/env bash

mkdir -p ~/Library/LaunchAgents

# Adopted from https://www.1password.dev/ssh/agent/compatibility#configure-ssh_auth_sock-globally-for-every-client

cat << EOF > ~/Library/LaunchAgents/com.bitwarden.SSH_AUTH_SOCK.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.bitwarden.SSH_AUTH_SOCK</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/sh</string>
    <string>-c</string>
    <string>/bin/ln -sf \$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock \$SSH_AUTH_SOCK</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF
launchctl load -w ~/Library/LaunchAgents/com.bitwarden.SSH_AUTH_SOCK.plist
