#!/usr/bin/env bash

#                   GNU GENERAL PUBLIC LICENSE
#                       Version 3, 29 June 2007
#
# Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#
# Script by @mrjarvis698

. $(pwd)/export.sh

# Telegram Bot
sendMessage() {
    MESSAGE=$1
    curl -s "https://api.telegram.org/bot${BOT_API_KEY}/sendmessage" --data "text=$MESSAGE&chat_id=${BOT_CHAT_ID}" 1>/dev/null
    echo -e
}

#Set Date and Time
export BUILD_DATE=$(date +%Y%m%d)
export BUILD_TIME=$(date +%H%M)

# Repo Init
sendMessage "Repo Initializing."
if [[ $depth -eq true ]]; then
	repo init --depth=1 -u ${android_manifest_url} -b ${manifest_branch}
else
	repo init -u ${android_manifest_url} -b ${manifest_branch}
fi
sendMessage "Repo Initialised Successfully."

# Repo Sync
sendMessage "Repo Synchronizing."
repo sync -j$(nproc --all) --force-sync --no-tags --no-clone-bundle
sendMessage "Repo Synchronized Successfully."

# ccache
export PATH="$(pwd)/ccache/:$PATH"
export USE_CCACHE=1
export CCACHE_EXEC=$(pwd)/ccache
ccache -M 25G
export _JAVA_OPTIONS=-Xmx14g

# Build Environment
. $(pwd)/build/envsetup.sh

# Lunch device
sendMessage "Lunching ${device_name}, Check Progress here-> ${BUILD_URL}"
lunch "${device_prefix}_${device_name}"-"${build_variant}"
sendMessage "Lunched ${device_name} Successfully."

# Build Rom
sendMessage "Starting Build for ${device_name}."
${make_rom}
if ls out/target/product/${device_name}/${rom_name}*_.zip 1> /dev/null 2>&1; then
	sendMessage "Build Completed"
	sendMessage "Uploading Build To Drive"
	rclone copy -P out/target/product/${device_name}/${rom_name}*.zip gdrive:${device_name}
	sendMessage "Uploaded to Google-Drive"
else
	sendMessage "Build Failed! Rebuilding for logs"
	make installclean
	${make_rom} | tee errorlog-${BUILD_DATE}-${BUILD_TIME}.txt
   if ls out/target/product/${device-name}/${rom_name}*.zip 1> /dev/null 2>&1; then
	sendMessage "Build Completed"
	sendMessage "Uploading Build To Drive"
	rclone copy -P out/target/product/${device_name}/${rom_name}*.zip gdrive:${device-name}
	sendMessage "Uploaded to Google-Drive"
   else
	sendMessage "Build Failed! Check Logs"
	rclone copy -P errorlog-${BUILD_DATE}-${BUILD_TIME}.txt gdrive:${device_name}
   fi
fi