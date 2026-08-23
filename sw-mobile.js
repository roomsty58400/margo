/* Service worker de l'édition mobile de Margo (margo-mobile.html) — copie de
   sw.js adaptée à ce fichier (nom de cache et liste de fichiers propres, pour
   ne jamais interférer avec le service worker de margo.html). Ne met en
   cache que la coquille de l'application (le fichier HTML lui-même, le
   manifest, les icônes, le logo) pour une ouverture instantanée et un usage
   possible hors-ligne. Les appels vers des services externes (Google Maps/
   Places/Directions, Nominatim, Overpass, polices, QR codes, photos...) ne
   sont volontairement PAS interceptés : ils doivent toujours atteindre le
   réseau pour renvoyer des données à jour (et pour ne jamais mettre en cache
   une clé API ou une réponse liée à un compte).

   IMPORTANT — CACHE_NAME doit être incrémenté à chaque modification de
   margo-mobile.html (ou des autres fichiers de CORE_ASSETS) : la stratégie
   "cache d'abord, mise à jour en arrière-plan" ci-dessous sert toujours la
   version déjà en cache en priorité, donc un appareil qui a ouvert l'appli
   avant un correctif peut continuer à voir l'ancienne version pendant
   plusieurs visites (ex. observé le 23/08 : résultats obsolètes puis carte
   cassée sur un smartphone déjà installé, alors que le site en ligne était
   déjà corrigé). Changer CACHE_NAME force chaque appareil à repartir d'un
   cache neuf dès la prochaine visite en ligne. */

const CACHE_NAME = 'margo-mobile-shell-v6';
const CORE_ASSETS = [
  './margo-mobile.html',
  './manifest-mobile.json',
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
      .catch(err => console.warn('Margo mobile SW: mise en cache initiale partielle', err))
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
