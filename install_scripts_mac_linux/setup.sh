#!/bin/sh

# To install the host program. Run $bash setup.sh from the terminal: 
set -e

# Step 1: Check Java version 1.8+
 
if type -p java; then
    # echo found java executable in PATH
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    # echo found java executable in JAVA_HOME     
    _java="$JAVA_HOME/bin/java"
else
    echo "Java seems not installed."
fi

if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    # echo version "$version"
    if [[ "$version" > 1.8 ]]; then
        echo Proper Java version is installed.
    else         
        echo It requires Java version 1.8 or higher.
        echo Please download the latest Java before the setup.
        JAVA_URL="https://java.com/download/"
        echo "$JAVA_URL"
        open $JAVA_URL
        exit 1
    fi
fi

# Step 2: Ask user to installation.

echo "Factify will require 42MB of the disk space."
echo "Press any key to proceed."
read ans


# Step 3: Create factpub folder under $HOME

#echo "create the folder"
HOST_DIR="$HOME/factpub_chrome_host"

#echo $HOST_DIR

rm -fr $HOST_DIR
mkdir $HOST_DIR

# Step 4: Download necessary files from factpub.org to the working folder

curl -o $HOST_DIR/org.factpub.factify.json http://factpub.org/public/factify_ChromeExtension/install_scripts_mac_linux/org.factpub.factify.json
curl -o $HOST_DIR/factify_launcher.sh http://factpub.org/public/factify_ChromeExtension/install_scripts_mac_linux/factify_launcher
curl -o $HOST_DIR/uninstall.sh http://factpub.org/public/factify_ChromeExtension/install_scripts_mac_linux/uninstall
curl -o $HOST_DIR/factify.jar http://factpub.org/public/factify_ChromeExtension/_factify.jar

chmod 755 $HOST_DIR/factify_launcher.sh
chmod 755 $HOST_DIR/uninstall.sh

# Step 5: Register the host program.

if [ "$(uname -s)" = "Darwin" ]; then
  if [ "$(whoami)" = "root" ]; then
    TARGET_DIR="/Library/Google/Chrome/NativeMessagingHosts"
  else
    TARGET_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
  fi
else
  if [ "$(whoami)" = "root" ]; then
    TARGET_DIR="/etc/opt/chrome/native-messaging-hosts"
  else
    TARGET_DIR="$HOME/.config/google-chrome/NativeMessagingHosts"
  fi
fi
HOST_NAME=org.factpub.factify
# Create directory to store native messaging host.
mkdir -p "$TARGET_DIR"
# Copy native messaging host manifest.
cp "$HOST_DIR/$HOST_NAME.json" "$TARGET_DIR"

# Update host path in the manifest.
HOST_PATH="$HOST_DIR/factify_launcher.sh"
ESCAPED_HOST_PATH=${HOST_PATH////\\/}

# Substitute the HOST_PATH with actual path of the host program
sed -i -e "s/HOST_PATH/$ESCAPED_HOST_PATH/" "$TARGET_DIR/$HOST_NAME.json"

# Set permissions for the manifest so that all users can read it.
chmod o+r "$TARGET_DIR/$HOST_NAME.json"
echo "Native messaging host $HOST_NAME has been installed."


# Step 6: Wait till user input and close.
