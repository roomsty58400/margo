/* Service worker de Margo — met en cache uniquement la coquille de
   l'application (le fichier HTML lui-même, les icônes, le logo, le gif) pour
   qu'elle s'ouvre instantanément et reste utilisable même sans réseau.
   Les appels vers des services externes (Google Maps/Places/Directions,
   Nominatim, Overpass, polices, QR codes, photos...) ne sont volontairement
   PAS interceptés : ils doivent toujours atteindre le réseau pour renvoyer
   des données à jour (et pour ne jamais mettre en cache une clé API ou une
   réponse liée à un compte). */

const CACHE_NAME = 'margo-shell-v8';
const CORE_ASSETS = [
  './margo.html',
  './manifest.json',
  './assets/images/margo-logo.png',
  './assets/images/snail-route.svg',
  './assets/icons/icon-192.png',
  './assets/icons/icon-512.png',
  './assets/icons/icon-192-maskable.png',
  './assets/icons/icon-512-maskable.png',
  './assets/icons/apple-touch-icon.png',
  './pages/mentions-legales.html'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(CORE_ASSETS))
      .catch(err => console.warn('Margo SW: mise en cache initiale partielle', err))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(names =>
      Promise.all(names.filter(n => n !== CACHE_NAME).map(n => caches.delete(n)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  const req = event.request;
  const url = new URL(req.url);

  // Seules les requêtes GET vers notre propre origine (la coquille de
  // l'appli) passent par le cache ; tout le reste (APIs tierces, données
  // dynamiques) part directement sur le réseau, sans passer par le SW.
  if(req.method !== 'GET' || url.origin !== self.location.origin){
    return;
  }

  event.respondWith(
    caches.match(req).then(cached => {
      const network = fetch(req).then(res => {
        if(res && res.ok){
          const copy = res.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(req, copy));
        }
        return res;
      }).catch(() => cached);
      // Cache d'abord (ouverture instantanée / hors-ligne), mise à jour en
      // arrière-plan dès que le réseau répond.
      return cached || network;
    })
  );
});
