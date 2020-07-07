#!/bin/bash -e

prompt_for_number() {
	local prompt_text=$1
	local default_value=$2
	local tmp=""
	while true; do
		read -p "$prompt_text [$default_value]: " tmp
		if [ "$tmp" = "" ]; then
			echo "$default_value"; return
		elif echo "$tmp" | grep -q -E '^[0-9]+$'; then
			echo "$tmp"; return
		fi
	done
}

# On a release the following actions are performed
# * DEVELOPMENT_BUILD is set to false
# * appdata release version and date are updated
# * Commit the changes
# * Tag with current version
perform_release() {
	sed -i -re "s/^set\(DEVELOPMENT_BUILD TRUE\)$/set(DEVELOPMENT_BUILD FALSE)/" CMakeLists.txt

	sed -i '/\<release/s/\(version\)="[^"]*"/\1="'"$RELEASE_VERSION"'"/' misc/net.minetest.minetest.appdata.xml

	RELEASE_DATE=`date +%Y-%m-%d`

	sed -i 's/\(<release date\)="[^"]*"/\1="'"$RELEASE_DATE"'"/' misc/net.minetest.minetest.appdata.xml

	git commit -m "Bump version to $RELEASE_VERSION"

	echo "Tagging $RELEASE_VERSION"

	git tag -a "$RELEASE_VERSION" -m "$RELEASE_VERSION"
}

# After release
# * Set DEVELOPMENT_BUILD to true
# * Bump version in CMakeLists and docs
# * Commit the changes
back_to_devel() {
	echo 'Creating "return back to development" commit'

	sed -i -re 's/^set\(DEVELOPMENT_BUILD FALSE\)$/set(DEVELOPMENT_BUILD TRUE)/' CMakeLists.txt

	sed -i -re "s/^set\(VERSION_MAJOR [0-9]+\)$/set(VERSION_MAJOR $NEXT_VERSION_MAJOR)/" CMakeLists.txt

	sed -i -re "s/^set\(VERSION_MINOR [0-9]+\)$/set(VERSION_MINOR $NEXT_VERSION_MINOR)/" CMakeLists.txt

	sed -i -re "s/^set\(VERSION_PATCH [0-9]+\)$/set(VERSION_PATCH $NEXT_VERSION_PATCH)/" CMakeLists.txt

	sed -i -re "1s/[0-9]+\.[0-9]+\.[0-9]+/$NEXT_VERSION/g" doc/menu_lua_api.txt

	sed -i -re "1s/[0-9]+\.[0-9]+\.[0-9]+/$NEXT_VERSION/g" doc/client_lua_api.txt

	git add -f CMakeLists.txt doc/menu_lua_api.txt doc/client_lua_api.txt

	git commit -m "Continue with $NEXT_VERSION-dev"
}
##################################
# Switch to top minetest directory
##################################

cd ${0%/*}/..


#######################
# Determine old version
#######################

# Make sure all the files we need exist
grep -q -E '^set\(VERSION_MAJOR [0-9]+\)$' CMakeLists.txt
grep -q -E '^set\(VERSION_MINOR [0-9]+\)$' CMakeLists.txt
grep -q -E '^set\(VERSION_PATCH [0-9]+\)$' CMakeLists.txt

VERSION_MAJOR=$(grep -E '^set\(VERSION_MAJOR [0-9]+\)$' CMakeLists.txt | tr -dC 0-9)
VERSION_MINOR=$(grep -E '^set\(VERSION_MINOR [0-9]+\)$' CMakeLists.txt | tr -dC 0-9)
VERSION_PATCH=$(grep -E '^set\(VERSION_PATCH [0-9]+\)$' CMakeLists.txt | tr -dC 0-9)

RELEASE_VERSION="$VERSION_MAJOR.$VERSION_MINOR.$VERSION_PATCH"

echo "Current Minetest version: $RELEASE_VERSION"

echo

########################
# Perform release
########################

perform_release

########################
# Prompt for next version
########################

NEXT_VERSION_MAJOR=$VERSION_MAJOR
NEXT_VERSION_MINOR=$VERSION_MINOR
NEXT_VERSION_PATCH=$(expr $VERSION_PATCH + 1)

NEXT_VERSION_MAJOR=$(prompt_for_number "Set next major" $NEXT_VERSION_MAJOR)

if [ "$NEXT_VERSION_MAJOR" != "$VERSION_MAJOR" ]; then
	NEXT_VERSION_MINOR=0
	NEXT_VERSION_PATCH=0
fi

NEXT_VERSION_MINOR=$(prompt_for_number "Set next minor" $NEXT_VERSION_MINOR)

if [ "$NEXT_VERSION_MINOR" != "$VERSION_MINOR" ]; then
	NEXT_VERSION_PATCH=0
fi

NEXT_VERSION_PATCH=$(prompt_for_number "Set next patch" $NEXT_VERSION_PATCH)

NEXT_VERSION="$NEXT_VERSION_MAJOR.$NEXT_VERSION_MINOR.$NEXT_VERSION_PATCH"

echo
echo "New version: $NEXT_VERSION"

########################
# Return back to devel
########################

back_to_devel
