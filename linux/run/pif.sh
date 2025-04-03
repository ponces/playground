#!/system/bin/sh

set -e

[ -z $DEBUG ] && DEBUG=true
[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

[ -z $FORCE_DEPTH ] && FORCE_DEPTH=1
[ -z $FORCE_PREVIEW ] && FORCE_PREVIEW=0

$DEBUG && echo "Pixel Beta pif.json generator script by osm0sis @ xda-developers"

$DEBUG && echo "Crawling Android Developers for latest Pixel Beta..."
wget -q -O $TMPDIR/PIXEL_VERSIONS_HTML --no-check-certificate https://developer.android.com/about/versions 2>&1 || exit 1
wget -q -O $TMPDIR/PIXEL_LATEST_HTML --no-check-certificate $(grep -o 'https://developer.android.com/about/versions/.*[0-9]"' $TMPDIR/PIXEL_VERSIONS_HTML | sort -ru | cut -d\" -f1 | head -n1) 2>&1 || exit 1
if grep -qE 'Developer Preview|tooltip>.*preview program' $TMPDIR/PIXEL_LATEST_HTML && [ ! "$FORCE_PREVIEW" ]; then
  wget -q -O $TMPDIR/PIXEL_BETA_HTML --no-check-certificate $(grep -o 'https://developer.android.com/about/versions/.*[0-9]"' $TMPDIR/PIXEL_VERSIONS_HTML | sort -ru | cut -d\" -f1 | head -n2 | tail -n1) 2>&1 || exit 1
else
  TITLE="Preview"
  mv -f $TMPDIR/PIXEL_LATEST_HTML $TMPDIR/PIXEL_BETA_HTML
fi
wget -q -O wget -q -O $TMPDIR/PIXEL_OTA_HTML --no-check-certificate https://developer.android.com$(grep -o 'href=".*download-ota.*"' $TMPDIR/PIXEL_BETA_HTML | cut -d\" -f2 | head -n$FORCE_DEPTH | tail -n1) 2>&1 || exit 1

BETA_REL_DATE="$(date -d "$(grep -m1 -A1 'Release date' $TMPDIR/PIXEL_OTA_HTML | tail -n1 | sed 's;.*<td>\(.*\)</td>.*;\1;')" '+%Y-%m-%d')"
BETA_EXP_DATE="$(date -d "@$(($(date -d "$BETA_REL_DATE" '+%s') + 60 * 60 * 24 * 7 * 6))" '+%Y-%m-%d')"

MODEL_LIST="$(grep -A1 'tr id=' $TMPDIR/PIXEL_OTA_HTML | grep 'td' | sed 's;.*<td>\(.*\)</td>;\1;')"
PRODUCT_LIST="$(grep -o 'ota/.*_beta' $TMPDIR/PIXEL_OTA_HTML | cut -d\/ -f2)"
OTA_LIST="$(grep 'ota/.*_beta' $TMPDIR/PIXEL_OTA_HTML | cut -d\" -f2)"

$DEBUG && echo "Selecting latest Pixel Beta device..."
MODEL="$(echo "$MODEL_LIST" | tail -n 1)"
PRODUCT="$(echo "$PRODUCT_LIST" | tail -n 1)"
OTA="$(echo "$OTA_LIST" | tail -n 1)"
DEVICE="$(echo "$PRODUCT" | sed 's/_beta//')"

timeout 1 wget -O $TMPDIR/PIXEL_ZIP_METADATA --no-check-certificate $OTA 2>/dev/null || true
FINGERPRINT="$(grep -am1 'post-build=' $TMPDIR/PIXEL_ZIP_METADATA | cut -d= -f2)"
SECURITY_PATCH="$(grep -am1 'security-patch-level=' $TMPDIR/PIXEL_ZIP_METADATA | cut -d= -f2)"
rm -f $TMPDIR/PIXEL_VERSIONS_HTML $TMPDIR/PIXEL_LATEST_HTML $TMPDIR/PIXEL_BETA_HTML $TMPDIR/PIXEL_OTA_HTML $TMPDIR/PIXEL_ZIP_METADATA

if [ -z "$FINGERPRINT" -o -z "$SECURITY_PATCH" ]; then
  echo "\nError: Failed to extract information from metadata!"
  exit 1
fi

$DEBUG && echo "Dumping values to minimal pif.json..."
cat << EOF
{
  "MANUFACTURER": "Google",
  "MODEL": "$MODEL",
  "FINGERPRINT": "$FINGERPRINT",
  "PRODUCT": "$PRODUCT",
  "DEVICE": "$DEVICE",
  "SECURITY_PATCH": "$SECURITY_PATCH",
  "DEVICE_INITIAL_SDK_INT": "32"
}
EOF
$DEBUG && echo "Release date: $BETA_REL_DATE"
$DEBUG && echo "Expiration date: $BETA_EXP_DATE"
