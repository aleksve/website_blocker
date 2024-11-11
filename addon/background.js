// List of websites to block
const blockedSites = [
  "*://*.facebook.com/*",
  "*://*.vg.no/*",
  "*://*.dagbladet.no/*",
  "*://*.db.no/*",
  "*://*.nrk.no/*",
  "*://*.aftenposten.no/*"
];

// Set up a listener to block requests to specified sites
chrome.webRequest.onBeforeRequest.addListener(
  function (details) {
    console.log("Blocking site:", details.url);
    return { cancel: true };
  },
  { urls: blockedSites },
  ["blocking"]
);
