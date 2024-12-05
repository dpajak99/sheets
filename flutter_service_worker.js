'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "f393d3c16b631f36852323de8e583132",
"main.dart.js": "af52dcb5083d10d74259ba4b2bbf26bd",
"assets/FontManifest.json": "9f722ab301b83ea248c76f91404549c3",
"assets/AssetManifest.bin": "c19034ce2e2c6386817da5a265877548",
"assets/fonts/MaterialIcons-Regular.otf": "267b18d5736be65fde9eb9b0a4e4c978",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-Bold.ttf": "dbea4253441a9fe3528a165bf7088972",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-Medium.ttf": "8fc2fb0e330a6080114dc5464841342c",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-MediumItalic.ttf": "c01bf508776073a7a8123a992ecf37dc",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-Regular.ttf": "91c7db023f1cb1013cc1a76ca0d3b707",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-Italic.ttf": "96d2e4bac919413f679479ef7616e69e",
"assets/packages/sheets/assets/fonts/GoogleSans/GoogleSans-BoldItalic.ttf": "7de14eb397ea126d49efb84a116ce4a0",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-Regular.ttf": "327362a7c8d487ad3f7970cc8e2aba8d",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-Thin.ttf": "8e1900eabb62e4e502ee3de329e0b833",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-MediumItalic.ttf": "18191c4ed1413aac2700bbfa58b90774",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-BlackItalic.ttf": "fc9c6dc66452de428b034f2af1a561ce",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-ThinItalic.ttf": "0d058ce1aecaa16d26b71bdab2be31b0",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-Black.ttf": "53ab4bb513d53af898e25637a2750ffc",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-Light.ttf": "5b55e48d4daee5634648dd487340e37e",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-Italic.ttf": "270c8dce1ab3c57848d7d278cb96574f",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-BoldItalic.ttf": "fa726104cd4b7e8f106e391fea744b08",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-LightItalic.ttf": "b4591abf6ddac60905ad8a2ac5ba5363",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-Medium.ttf": "6679d67d72e0e7b34f407bac6df715ab",
"assets/packages/sheets/assets/fonts/Roboto/Roboto-Bold.ttf": "2e9b3d16308e1642bf8549d58c60f5c9",
"assets/packages/sheets/assets/icons/format_color_reset.svg": "c2146d24c14babf1d19b30d92794a716",
"assets/packages/sheets/assets/icons/border_color.svg": "4a1997675ee138f743ac0ae0431b1523",
"assets/packages/sheets/assets/icons/keyboard_arrow_up.svg": "befecef6d848f2beb3281a938c880651",
"assets/packages/sheets/assets/icons/edit.svg": "a1a7a953381007d104bc97d68b2e2aeb",
"assets/packages/sheets/assets/icons/format_align_left.svg": "9fcbd5735efc9aeb961e172d38c44905",
"assets/packages/sheets/assets/icons/table_view.svg": "fc10b196e39636360b2337b8c286d396",
"assets/packages/sheets/assets/icons/format_text_wrap.svg": "90c0c0b6d735b12a592851a10bc6e584",
"assets/packages/sheets/assets/icons/text_rotation_vertical.svg": "928d74f692522a80ffaf791f426174c0",
"assets/packages/sheets/assets/icons/decimal_increase.svg": "5382e8f9f6481a406c5cbb2836be2788",
"assets/packages/sheets/assets/icons/remove.svg": "5bc4725b86b29911b19411c8472b82ae",
"assets/packages/sheets/assets/icons/format_align_justify.svg": "fcc04a87178b8de166b9a3dd876f6f69",
"assets/packages/sheets/assets/icons/format_align_center.svg": "71c84ce6638b02ee0615597d38b70fae",
"assets/packages/sheets/assets/icons/search.svg": "9f9aa3cf5e54968696fc71a3d8eb72f8",
"assets/packages/sheets/assets/icons/border_outer.svg": "8edfcc61f9a05a6689bbb71b24e768f6",
"assets/packages/sheets/assets/icons/format_color_text.svg": "05a0e21f16d2d30482d87dbd47416298",
"assets/packages/sheets/assets/icons/border_all.svg": "77f37b6c5395e2bf0154b52215ac5baf",
"assets/packages/sheets/assets/icons/text_increase.svg": "21d0eed1ddab275718750fb9cbb9eaef",
"assets/packages/sheets/assets/icons/colorize.svg": "b899eca5cc57b81a64dd2d615dea74ae",
"assets/packages/sheets/assets/icons/format_text_clip.svg": "30ce839fdafa4cdcbcf44cec9a145af8",
"assets/packages/sheets/assets/icons/link.svg": "42aac26d5e77c52d36623b2b52f5fa80",
"assets/packages/sheets/assets/icons/border_vertical.svg": "09b2a2c0d504c4460be877226b6c0d39",
"assets/packages/sheets/assets/icons/insert_chart.svg": "d2b511dd81b4484a64dd63ea96568ee9",
"assets/packages/sheets/assets/icons/add.svg": "128937e8636ffdbf9a2e95385f6612e4",
"assets/packages/sheets/assets/icons/check.svg": "911ace9feaaa6b5144b07e6219f57275",
"assets/packages/sheets/assets/icons/more_vert.svg": "b8aba93edd920aad42780addfa3a2701",
"assets/packages/sheets/assets/icons/function.svg": "792bb8fc879b4b2be4a71589d4e2267c",
"assets/packages/sheets/assets/icons/format_italic.svg": "7e7e4c9fdeb9da1509547348c63bcaad",
"assets/packages/sheets/assets/icons/format_color_fill.svg": "c7aff4aac052de2f6b5158243e915bb6",
"assets/packages/sheets/assets/icons/vertical_align_bottom.svg": "f89aed425a179bbdb2cb92a78d921b67",
"assets/packages/sheets/assets/icons/undo.svg": "8aee96ffd1c1056b0ca8c80e11e63fe9",
"assets/packages/sheets/assets/icons/add_fonts.svg": "69b1313aae5ddeb5fbef95f1056598c4",
"assets/packages/sheets/assets/icons/dropdown.svg": "88fe1b68fca6c6ae05db4c28949947d0",
"assets/packages/sheets/assets/icons/arrow_up.svg": "befecef6d848f2beb3281a938c880651",
"assets/packages/sheets/assets/icons/filter_alt.svg": "2c20fe71a0efb20c015d261aa8f5c9e5",
"assets/packages/sheets/assets/icons/percentage.svg": "7199e62f218a2d766526f552f323b446",
"assets/packages/sheets/assets/icons/cell_merge.svg": "6881bc56833809ce204154a9e8400c31",
"assets/packages/sheets/assets/icons/border_left.svg": "6dc27d830c5d1bb03202bde0c396cf2a",
"assets/packages/sheets/assets/icons/functions.svg": "c3af48f69c3793db5bd46f6db8fccfee",
"assets/packages/sheets/assets/icons/border_clear.svg": "b4cd6700dd7d90672008545d4720176f",
"assets/packages/sheets/assets/icons/footer_menu.svg": "5316e5cb2b6a41db54e5ce731af7a941",
"assets/packages/sheets/assets/icons/redo.svg": "4a86a1557e7cacc79a67dca04e816c92",
"assets/packages/sheets/assets/icons/border_bottom.svg": "f43860a423fa851dc029820cd5d755db",
"assets/packages/sheets/assets/icons/border_right.svg": "63c60697c257138d2644d6c0f146b3a3",
"assets/packages/sheets/assets/icons/decimal_decrease.svg": "b9b84261beb6885652d9875f0f2c1816",
"assets/packages/sheets/assets/icons/format_text_overflow.svg": "56d701ea93c1818692535867b4c32856",
"assets/packages/sheets/assets/icons/text_rotation_down.svg": "401c2619f794eda29434a581067e2d1f",
"assets/packages/sheets/assets/icons/border_top.svg": "dbe848cbe8717759c6b75d1f5425521d",
"assets/packages/sheets/assets/icons/border_horizontal.svg": "fed6026dd9b1b0c1d08d7b521530ea2e",
"assets/packages/sheets/assets/icons/format_align_right.svg": "3897a3e01e30bb5e0c736de579e90809",
"assets/packages/sheets/assets/icons/strikethrough.svg": "e67943548d64add586ed7fc642a12e2a",
"assets/packages/sheets/assets/icons/border_inner.svg": "4180063852a5409e70524ac921a1e7ed",
"assets/packages/sheets/assets/icons/vertical_align_top.svg": "4bb3ef4bcacc507a0b95473f0bdf8c8b",
"assets/packages/sheets/assets/icons/text_rotation_angleup.svg": "f65330202da1bcbffd8b7ca15da3a322",
"assets/packages/sheets/assets/icons/right_angle.svg": "8598ad1725f7a9dcc7c9c788bb961ea3",
"assets/packages/sheets/assets/icons/print.svg": "480bdbfa22445e0d1a08c4adbe54dfb3",
"assets/packages/sheets/assets/icons/text_rotation_up.svg": "c06cbb1beed626b8d11e2ee615d43491",
"assets/packages/sheets/assets/icons/add_circle.svg": "2ca2f4f344a394d0d50d3dca3e41f331",
"assets/packages/sheets/assets/icons/text_rotation_none.svg": "d86cd29a31b7990d7a19fa565155b12e",
"assets/packages/sheets/assets/icons/text_rotation_angledown.svg": "91bb68099360e362a8261a92f87b4fbd",
"assets/packages/sheets/assets/icons/vertical_align_center.svg": "1be050841c87a619ebe3c19235b9bb36",
"assets/packages/sheets/assets/icons/add_comment.svg": "da1c2e2ce0daf1fdfc858680d3de4baa",
"assets/packages/sheets/assets/icons/format_bold.svg": "454cad8511bfa452e0b11ef2fd39e90a",
"assets/packages/sheets/assets/icons/footer_add.svg": "2fc5a892244abd95e06dd5a84e481406",
"assets/packages/sheets/assets/icons/paint.svg": "237e9e5648480ae42706bc1684b9759f",
"assets/packages/sheets/assets/icons/line_style.svg": "85aeda858c59d20b0216bb76ce845d32",
"assets/NOTICES": "35b8b1d61a76d81f281028e5a41cf7eb",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "d069674cef0e1163cbdb93423e57f93a",
"assets/AssetManifest.bin.json": "64ece7d4372e87b8d6ca03613536ffc6",
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
"flutter_bootstrap.js": "97f761f5945df1b2d96c23a038be3779"};
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
