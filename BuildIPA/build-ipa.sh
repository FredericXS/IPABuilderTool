#!/bin/bash

set -e

cd "$(dirname "$0")"

WORKING_LOCATION=CurrentLocation
APPLICATION_NAME=BuiltApp

cp -r "$(pwd)/bin" "$WORKING_LOCATION"
cp -r entitlements.plist "$WORKING_LOCATION"

if [ ! -d "$WORKING_LOCATION/build" ]; then
    mkdir "$WORKING_LOCATION/build"
fi

cd "$WORKING_LOCATION/build"

xcodebuild -project "$WORKING_LOCATION/$APPLICATION_NAME.xcodeproj" \
    -scheme "$APPLICATION_NAME" \
    -configuration Release \
    -derivedDataPath "$WORKING_LOCATION/build/DerivedDataApp" \
    -destination 'generic/platform=iOS' \
    clean build \
    CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"

DD_APP_PATH="$WORKING_LOCATION/build/DerivedDataApp/Build/Products/Release-iphoneos/$APPLICATION_NAME.app"
TARGET_APP="$WORKING_LOCATION/build/$APPLICATION_NAME.app"
cp -r "$DD_APP_PATH" "$TARGET_APP"

codesign --remove "$TARGET_APP"
if [ -e "$TARGET_APP/_CodeSignature" ]; then
    rm -rf "$TARGET_APP/_CodeSignature"
fi
if [ -e "$TARGET_APP/embedded.mobileprovision" ]; then
    rm -rf "$TARGET_APP/embedded.mobileprovision"
fi

# Add entitlements
echo "Adding entitlements"
chmod a+x $WORKING_LOCATION/bin/ldid
$WORKING_LOCATION/bin/ldid -S"$WORKING_LOCATION/entitlements.plist" "$TARGET_APP/$APPLICATION_NAME"

mkdir "$WORKING_LOCATION/Payload"
cp -r "$WORKING_LOCATION/build/$APPLICATION_NAME.app" "$WORKING_LOCATION/Payload/$APPLICATION_NAME.app"
zip -vr "$WORKING_LOCATION/$APPLICATION_NAME.ipa" "$WORKING_LOCATION/Payload"

# Removing trash
rm -rf "$WORKING_LOCATION/$APPLICATION_NAME.app"
rm -rf "$WORKING_LOCATION/Payload"
rm -rf "$WORKING_LOCATION/build"
rm -rf "$WORKING_LOCATION/bin"
rm -rf "$WORKING_LOCATION/entitlements.plist"