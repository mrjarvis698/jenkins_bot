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

# Repo Init
if [ $depth == true ]
then
	repo init --depth=1 -u ${android_manifest_url} -b ${manifest_branch}
else
	repo init -u ${android_manifest_url} -b ${manifest_branch}
fi

# Repo Sync
repo sync -j$(nproc --all) --force-sync --no-tags --no-clone-bundle

# ccache
export PATH="$(pwd)/ccache/:$PATH"
export USE_CCACHE=1
export CCACHE_EXEC=$(pwd)/ccache
ccache -M 25G
export _JAVA_OPTIONS=-Xmx14g