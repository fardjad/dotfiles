#!/usr/bin/env bash

set -e

source "$(dirname "$0")/../../script/bootstrap.bash"

if ! is_mac; then
  info "This machine is not running macOS. Skipping..."
  exit 0
fi

# PlistBuddy is built into macOS by default
if ! check_command /usr/libexec/PlistBuddy; then
  fail "PlistBuddy is required for this script to work"
fi

set_plist_key() {
  local plist="$1"
  local key="$2"
  local type="$3"
  local value="$4"

  if ! /usr/libexec/PlistBuddy -c "Print $key" "$plist" &> /dev/null; then
    sudo /usr/libexec/PlistBuddy -c "Add $key $type $value" "$plist"
  else
    sudo /usr/libexec/PlistBuddy -c "Set $key $value" "$plist"
  fi
}

set_plist_array() {
  local plist="$1"
  local key="$2"
  shift 2
  local items=("$@")

  sudo /usr/libexec/PlistBuddy -c "Delete $key" "$plist" 2> /dev/null
  sudo /usr/libexec/PlistBuddy -c "Add $key array" "$plist"
  for i in "${!items[@]}"; do
    sudo /usr/libexec/PlistBuddy -c "Add $key:$i string ${items[$i]}" "$plist"
  done
}

plist="/Library/Managed Preferences/com.brave.Browser.plist"

# Brave Specific

# Disable=true
set_plist_key "$plist" ":BraveWalletDisabled" "bool" "true"
set_plist_key "$plist" ":BraveRewardsDisabled" "bool" "true"
set_plist_key "$plist" ":BraveVPNDisabled" "bool" "true"
set_plist_key "$plist" ":BraveNewsDisabled" "bool" "true"
set_plist_key "$plist" ":BraveTalkDisabled" "bool" "true"

# Enable=false
set_plist_key "$plist" ":BraveAIChatEnabled" "bool" "false"
set_plist_key "$plist" ":BraveP3AEnabled" "bool" "false"
set_plist_key "$plist" ":BraveStatsPingEnabled" "bool" "false"
set_plist_key "$plist" ":BraveWebDiscoveryEnabled" "bool" "false"

# Chromium
set_plist_key "$plist" ":PasswordManagerEnabled" "bool" "false"
set_plist_key "$plist" ":AutofillCreditCardEnabled" "bool" "false"
set_plist_key "$plist" ":AutofillAddressEnabled" "bool" "false"
set_plist_key "$plist" ":PaymentMethodQueryEnabled" "bool" "false"

info "restarting cfprefsd"
sudo killall cfprefsd

user "restart Brave to see the effect"
