#!/usr/bin/env bash

#                   GNU GENERAL PUBLIC LICENSE
#                       Version 3, 29 June 2007
#
# Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#
# Script by @mrjarvis698

#Predefined Exports

#Repo Init
export depth="[true/false]"
export android_manifest_url="[Manifest Url]"
export manifest_branch="[Manifest Branch]"

# Lunch device
export device_prefix="[device prefix like du/rr/revengeos]"
export device_name="[devicename]"
export build_variant="[eng/userdebug/user]"

# Make Rom
export make_rom="[mka bacon/make/Rom Make Choice]"

# Telegram Bot
export BOT_API_KEY="[Telegram Bot API Token]"
export BOT_CHAT_ID="[Chat ID of User or Group]"