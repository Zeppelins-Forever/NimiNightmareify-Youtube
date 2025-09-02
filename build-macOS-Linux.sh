#!/bin/bash

# Display ASCII art banner
cat << "EOF"
 _   _ _           _ _   _ _       _     _                            _  __
| \ | (_)         (_) \ | (_)     | |   | |                          (_)/ _|
|  \| |_ _ __ ___  _|  \| |_  __ _| |__ | |_ _ __ ___   __ _ _ __ ___ _| |_ _ _ _
| . ` | | '_ ` _ \| | . ` | |/ _` | '_ \| __| '_ ` _ \ / _` | '__/ _ \|  _| | | |
| |\  | | | | | | | | |\  | | (_| | | | | |_| | | | | | (_| | |  __/ | | | |_| |
|_| \_|_|_| |_| |_|_|_| \_|_|\__, |_| |_|\__|_| |_| |_|\__,_|_|  \___|_|_|  \__, |
|  _ \      (_) |   | |       __/ |                                          __/ |
| |_) |_   _ _| | __| | ___ _|___/                                          |___/
|  _ <| | | | | |/ _` |/ _ \ '__|
| |_) | |_| | | | (_| |  __/ |
|____/ \__,_|_|_|\__,_|\___|_|

EOF

# Define variables
ZIP_NAME_FIREFOX="Firefox.zip"
ZIP_NAME_CHROMIUM="Chromium.zip"
SOURCE_FOLDER="$(pwd)"
TEMP_FOLDER="${SOURCE_FOLDER}/temp"

# Function to check if zip command is available
check_zip() {
    if ! command -v zip >/dev/null 2>&1; then
        echo "ERROR: zip command is not installed."
        echo "Please install zip package:"
        echo "  On Ubuntu/Debian: sudo apt-get install zip"
        echo "  On CentOS/RHEL: sudo yum install zip"
        echo "  On macOS: zip should be pre-installed, or install via: brew install zip"
        exit 1
    fi
}

# Function to clean and create temp directory
setup_temp_dir() {
    if [ -d "$TEMP_FOLDER" ]; then
        rm -rf "$TEMP_FOLDER"
    fi
    mkdir -p "$TEMP_FOLDER"
}

# Function to copy files for Firefox
copy_firefox_files() {
    echo "Copying files to the temp directory for Firefox..."
    cp "$SOURCE_FOLDER/manifest.json" "$TEMP_FOLDER/"
    cp "$SOURCE_FOLDER/niminightmareify.js" "$TEMP_FOLDER/"
    cp -r "$SOURCE_FOLDER/images" "$TEMP_FOLDER/"
    cp "$SOURCE_FOLDER/icon.png" "$TEMP_FOLDER/"
    cp "$SOURCE_FOLDER/settings.html" "$TEMP_FOLDER/"
    cp "$SOURCE_FOLDER/settings.js" "$TEMP_FOLDER/"
}

# Function to copy files for Chromium
copy_chromium_files() {
    echo "Copying files to the temp directory for Chromium..."
    cp "$SOURCE_FOLDER/niminightmareify.js" "$TEMP_FOLDER/"
    cp "$SOURCE_FOLDER/manifest v3.json" "$TEMP_FOLDER/"
    cp -r "$SOURCE_FOLDER/images" "$TEMP_FOLDER/"
    cp "$SOURCE_FOLDER/icon.png" "$TEMP_FOLDER/"
    cp "$SOURCE_FOLDER/settings.html" "$TEMP_FOLDER/"
    cp "$SOURCE_FOLDER/settings.js" "$TEMP_FOLDER/"
}

# Function to create zip file
create_zip() {
    local zip_name="$1"
    echo "Creating $zip_name..."
    (cd "$TEMP_FOLDER" && zip -r "../$zip_name" . >/dev/null 2>&1)
    if [ $? -eq 0 ]; then
        echo "$zip_name created successfully."
    else
        echo "ERROR: Failed to create $zip_name"
        exit 1
    fi
}

# Main execution
main() {
    # Check if zip is available
    check_zip
    
    # Build Firefox extension
    echo "Building Firefox extension..."
    setup_temp_dir
    copy_firefox_files
    create_zip "$ZIP_NAME_FIREFOX"
    
    # Build Chromium extension
    echo "Building Chromium extension..."
    setup_temp_dir
    copy_chromium_files
    
    # Rename manifest for Chromium
    echo "Preparing files for Chromium zip..."
    mv "$TEMP_FOLDER/manifest v3.json" "$TEMP_FOLDER/manifest.json"
    
    create_zip "$ZIP_NAME_CHROMIUM"
    
    # Cleanup
    if [ -d "$TEMP_FOLDER" ]; then
        rm -rf "$TEMP_FOLDER"
    fi
    
    echo "All operations completed successfully."
    echo "Press Enter to continue..."
    read
}

# Run main function
main
