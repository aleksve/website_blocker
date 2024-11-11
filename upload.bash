#!/bin/bash
set -eu

# Variables - replace with your actual values
ADDON_ID="c7f5a3b213924e029ef0"
VERSION="1.0.6"
XPI_FILE="block-site.xpi"
[ ! -f ${XPI_FILE} ] && echo "File ${XPI_FILE} not found" && exit 1
CHANNEL="listed"

# Generate JWT token
now=$(date +%s)
iat="${now}"
exp=$((now + 60))
header=$(echo -n '{"alg":"HS256","typ":"JWT"}' | openssl base64 -e | tr -d '=' | tr '/+' '_-' | tr -d '\n')
payload=$(echo -n "{\"iss\":\"$JWT_ISSUER\",\"iat\":$iat,\"exp\":$exp}" | openssl base64 -e | tr -d '=' | tr '/+' '_-' | tr -d '\n')
signature=$(echo -n "${header}.${payload}" | openssl dgst -sha256 -hmac "$JWT_SECRET" -binary | openssl base64 -e | tr -d '=' | tr '/+' '_-' | tr -d '\n')
jwt_token="${header}.${payload}.${signature}"

echo "JWT Token: $jwt_token"

# Step 1: Upload the add-on file for validation
UPLOAD_URL="https://addons.mozilla.org/api/v5/addons/upload/"
upload_response=$(curl -v -X POST "$UPLOAD_URL" \
     -H "Authorization: JWT ${jwt_token}" \
     -F "upload=@${XPI_FILE}" \
     -F "channel=${CHANNEL}")

echo "Upload response: $upload_response"

# Extract the UUID
upload_uuid=$(echo "$upload_response" | jq -r '.uuid')

if [ -z "$upload_uuid" ] || [ "$upload_uuid" == "null" ]; then
    echo "Upload failed. Response: $upload_response"
    exit 1
fi

# Delay to ensure the upload completes processing
sleep 5

# Step 2: Attach the validated file as a new version with license
VERSION_URL="https://addons.mozilla.org/api/v5/addons/addon/${ADDON_ID}/versions/"
version_response=$(curl -v -X POST "$VERSION_URL" \
     -H "Authorization: JWT ${jwt_token}" \
     -H "Content-Type: application/json" \
     -d "{\"upload\": \"${upload_uuid}\", \"license\": \"MIT\"}")

echo "Version response: $version_response"

# Check if the version was created successfully
if echo "$version_response" | jq -e '.id' > /dev/null; then
    echo "New version uploaded successfully."
else
    echo "Failed to create new version. Response: $version_response"
    exit 1
fi
