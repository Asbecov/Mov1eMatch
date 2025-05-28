'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-192.png": "5fbb66d70b2c378fc9daa0430d297257",
"icons/Icon-maskable-512.png": "8a6f6e32fc62b96748299b5d99a2b5e4",
"icons/Icon-maskable-192.png": "5fbb66d70b2c378fc9daa0430d297257",
"icons/Icon-512.png": "8a6f6e32fc62b96748299b5d99a2b5e4",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.mjs": "43caea738f19fd6c5835b95c2529fa91",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "825e75415ebd366b740bb49659d7a5c6",
"assets/AssetManifest.bin": "46bc6157b6f632463a0fa356f1af7cd1",
"assets/fonts/Montserrat-Italic-VariableFont_wght.ttf": "5a669c0a71801494df35130ab2f55295",
"assets/fonts/MaterialIcons-Regular.otf": "cc734b69dfdab3fdafa6a3e37629a683",
"assets/fonts/Montserrat-VariableFont_wght.ttf": "b87689f37dfb5c51719210e4d96a34a2",
"assets/AssetManifest.json": "b9a9dc3521e3f4d39571aaffe575a9e6",
"assets/FontManifest.json": "23a68185ea93fbf6daa6a42009346f95",
"assets/assets/number_two.svg": "ec03872aa056105213b51618564382fa",
"assets/assets/logo.svg": "177cfe11a2db500bdc4721c0ad49bd11",
"assets/assets/logo_with_text.svg": "e899ffde588d470224f76c63a88060f1",
"assets/assets/unknown.png": "00aecd9702eadb0b748bd4f496fcce5d",
"assets/assets/number_one.svg": "b5d753b31d1f0e260dc40c58dafd3ff6",
"assets/assets/number_three.svg": "9faad3749d5f2ea90df3cab5e6a91c6c",
"assets/NOTICES": "cecdb5ddad7712a588d5dd3683a7c6dc",
"assets/AssetManifest.bin.json": "b6e17d72c1c5341b690d2f504e9d4097",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"splash/img/light-2x.png": "84574607f8ffdf609736f76387e1edd3",
"splash/img/dark-2x.png": "84574607f8ffdf609736f76387e1edd3",
"splash/img/light-1x.png": "560e0af91d95e1f2286e3f5bc85232ab",
"splash/img/dark-1x.png": "560e0af91d95e1f2286e3f5bc85232ab",
"splash/img/dark-3x.png": "4d73d997c8f1fdd461ce6b5244d3bc84",
"splash/img/light-4x.png": "ad6ca66099091a67578ebfae2ec44ea6",
"splash/img/light-3x.png": "4d73d997c8f1fdd461ce6b5244d3bc84",
"splash/img/dark-4x.png": "ad6ca66099091a67578ebfae2ec44ea6",
"manifest.json": "37b4b14ba0f4ecec726b5b1f91587e3e",
"index.html": "253c6538e723f4bd293412acef2076b8",
"/": "253c6538e723f4bd293412acef2076b8",
"main.dart.wasm": "b26751f57f2fa80d7aa9c2367287061c",
"version.json": "291b8c81cce7d3c853da46aa9498dc51",
"flutter_bootstrap.js": "07b883a92570e48a1bf708397f22fd65",
"main.dart.js": "2b3a3fdcbe7dc9c82c773d9d126785a7",
"favicon.png": "10c827c48e7497f920d6e6a7245d6833"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
