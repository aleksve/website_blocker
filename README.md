
# Website Blocker Addon

This Firefox addon quietly blocks access to specified websites to help prevent time-wasting. The list of sites to block can be customized in the `background.js` file.

## How It Works

Once installed, the addon will automatically block any sites listed in `background.js`. Users attempting to access these sites will be redirected or shown a blocked message, encouraging more productive use of time.

## Installation

To install the latest version:
1. Go to the [Website Blocker Addon Page](https://addons.mozilla.org/en-US/developers/addon/c7f5a3b213924e029ef0/versions/5840995).
2. Click the `.xpi` file link to download and add the addon to Firefox.

## Building and Uploading a New Version

1. **Build**: Run `create_addon.bash` to build the addon.
2. **Upload**: Upload the built file to the Firefox Addon Developer Hub at [Developer Page](https://addons.mozilla.org/en-US/developers/addon/c7f5a3b213924e029ef0/versions).

**Note**: Currently, the process for automated uploads is experimental and has not yet been successful.

## Customization

To customize the sites that are blocked:
1. Open `background.js`.
2. Add or remove sites from the block list.
3. Rebuild and re-upload the addon for changes to take effect.
