'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "f393d3c16b631f36852323de8e583132",
"main.dart.js": "5dcc7b7efa885fad38e0cd24cf980167",
"assets/FontManifest.json": "c6f8de1018e16156689f4e6a34d5c44f",
"assets/AssetManifest.bin": "23d6b9a508862e99547a4035870de6d1",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-Bold.ttf": "4457817ac2b9993c65e81aa05828fe9c",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-Medium.ttf": "8d57e4014b18edef070d285746485115",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-MediumItalic.ttf": "8fd3737925e83c87d78a13700ccf9a62",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-Regular.ttf": "b5c77a6aed75cdad9489effd0d5ea411",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-Italic.ttf": "0ecddcdeccb7761ce899aa9ad9f0ac3f",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-BoldItalic.ttf": "90773b6158663ab0fe78b32680733677",
"assets/packages/sheets/assets/icons/keyboard_arrow_up.svg": "befecef6d848f2beb3281a938c880651",
"assets/packages/sheets/assets/icons/format_align_left.svg": "9fcbd5735efc9aeb961e172d38c44905",
"assets/packages/sheets/assets/icons/table_view.svg": "fc10b196e39636360b2337b8c286d396",
"assets/packages/sheets/assets/icons/decimal_increase.svg": "5382e8f9f6481a406c5cbb2836be2788",
"assets/packages/sheets/assets/icons/remove.svg": "5bc4725b86b29911b19411c8472b82ae",
"assets/packages/sheets/assets/icons/search.svg": "9f9aa3cf5e54968696fc71a3d8eb72f8",
"assets/packages/sheets/assets/icons/format_color_text.svg": "5d60d084fd590ce8fc1aadb1d4711be9",
"assets/packages/sheets/assets/icons/border_all.svg": "77f37b6c5395e2bf0154b52215ac5baf",
"assets/packages/sheets/assets/icons/link.svg": "42aac26d5e77c52d36623b2b52f5fa80",
"assets/packages/sheets/assets/icons/insert_chart.svg": "d2b511dd81b4484a64dd63ea96568ee9",
"assets/packages/sheets/assets/icons/add.svg": "128937e8636ffdbf9a2e95385f6612e4",
"assets/packages/sheets/assets/icons/more_vert.svg": "b8aba93edd920aad42780addfa3a2701",
"assets/packages/sheets/assets/icons/function.svg": "792bb8fc879b4b2be4a71589d4e2267c",
"assets/packages/sheets/assets/icons/format_italic.svg": "7e7e4c9fdeb9da1509547348c63bcaad",
"assets/packages/sheets/assets/icons/format_color_fill.svg": "ed7c27c0ee2bf0fc7c372db1bc952e3f",
"assets/packages/sheets/assets/icons/vertical_align_bottom.svg": "f89aed425a179bbdb2cb92a78d921b67",
"assets/packages/sheets/assets/icons/undo.svg": "8aee96ffd1c1056b0ca8c80e11e63fe9",
"assets/packages/sheets/assets/icons/dropdown.svg": "88fe1b68fca6c6ae05db4c28949947d0",
"assets/packages/sheets/assets/icons/arrow_up.svg": "befecef6d848f2beb3281a938c880651",
"assets/packages/sheets/assets/icons/filter_alt.svg": "2c20fe71a0efb20c015d261aa8f5c9e5",
"assets/packages/sheets/assets/icons/percentage.svg": "7199e62f218a2d766526f552f323b446",
"assets/packages/sheets/assets/icons/cell_merge.svg": "6881bc56833809ce204154a9e8400c31",
"assets/packages/sheets/assets/icons/functions.svg": "c3af48f69c3793db5bd46f6db8fccfee",
"assets/packages/sheets/assets/icons/footer_menu.svg": "5316e5cb2b6a41db54e5ce731af7a941",
"assets/packages/sheets/assets/icons/redo.svg": "4a86a1557e7cacc79a67dca04e816c92",
"assets/packages/sheets/assets/icons/decimal_decrease.svg": "b9b84261beb6885652d9875f0f2c1816",
"assets/packages/sheets/assets/icons/format_text_overflow.svg": "56d701ea93c1818692535867b4c32856",
"assets/packages/sheets/assets/icons/strikethrough.svg": "e67943548d64add586ed7fc642a12e2a",
"assets/packages/sheets/assets/icons/print.svg": "480bdbfa22445e0d1a08c4adbe54dfb3",
"assets/packages/sheets/assets/icons/text_rotation_none.svg": "f9c48906cbf19f88b0ea19089f2f564e",
"assets/packages/sheets/assets/icons/add_comment.svg": "da1c2e2ce0daf1fdfc858680d3de4baa",
"assets/packages/sheets/assets/icons/format_bold.svg": "454cad8511bfa452e0b11ef2fd39e90a",
"assets/packages/sheets/assets/icons/footer_add.svg": "2fc5a892244abd95e06dd5a84e481406",
"assets/packages/sheets/assets/icons/paint.svg": "237e9e5648480ae42706bc1684b9759f",
"assets/NOTICES": "b89db9b5434ae8d17d879d4f10189359",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "86734f3890698c82fc22c548d812dfaf",
"assets/AssetManifest.bin.json": "8d12143516b6cb2e694820a2226040ce",
"index.html": "edf600beab7d4a0ec812a696b91ab938",
"/": "edf600beab7d4a0ec812a696b91ab938",
"manifest.json": "0867c3e13649ac4d06fe34b7b3ddce08",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "ff966ab969ba381b900e61629bfb9789",
"flutter_bootstrap.js": "a0313e7bad7b803c9290ad77bd1ab971"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
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
