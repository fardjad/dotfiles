function upgrade-nodejs {
  if ! command -v "nvs" > /dev/null 2>&1; then
    echo "nvs is not installed. Please install it first."
    return 1
  fi

  echo "Checking for globally installed outdated packages...\n"

  \npm exec --package=npm-check-updates -- ncu -e2 -ug

  if [ $? -ne 0 ]; then
    return 1
  fi

  echo "\nUpgrading to the latest patch of the current version...\n"

  nvs upgrade
  source_version_with_prefix="$(node --version)"
  source_version="${source_version_with_prefix#v}"

  echo "\nCleaning up old versions...\n"

  for version in $(nvs ls | grep -Ev "[#>]node" | cut -d'/' -f2); do
    nvs rm "$version"
  done

  echo "\nInstalling the latest LTS version...\n"

  nvs add lts
  nvs link lts
  nvs migrate "$source_version" lts

  echo "\nDone."
  echo "You can safely ignore 'Source and target versions may not be the same' error messages."
}
