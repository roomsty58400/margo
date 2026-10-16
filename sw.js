/* Service worker de Margo — met en cache uniquement la coquille de
   l'application (le fichier HTML lui-même, les icônes, le logo, le gif) pour
   qu'elle s'ouvre instantanément et reste utilisable même sans réseau.
   Les appels vers des services externes (Google Maps/Places/Directions,
   Nominatim, Overpass, polices, QR codes, photos...) ne sont volontairement
   PAS interceptés : ils doivent toujours atteindre le réseau pour renvoyer
   des données à jour (et pour ne jamais mettre en cache une clé API ou une
   réponse liée à un compte). */

const CACHE_NAME = 'margo-shell-v19';
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
  './pages/mentions-legales.html',
  // Bourgou (même dépôt, même service worker)
  './bourgo.html',
  './manifest-bourgou.json',
  './assets/icons/bourgou-192.png',
  './assets/icons/bourgou-512.png',
  './assets/icons/bourgou-apple-touch-icon.png',
  './pages/mentions-legales-bourgou.html'
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
  // Fichiers de clés (apiki.env, AQ.env) : jamais mis en cache.
  if(url.pathname.endsWith('.env')){
    return;
  }

  // Page HTML : réseau d'abord, pour que chaque modification de l'appli
  // soit visible dès le rechargement (avec "cache d'abord", l'ancienne
  // version restait affichée jusqu'au rechargement suivant). Le cache ne
  // sert plus que de repli hors-ligne.
  if(req.mode === 'navigate' || url.pathname.endsWith('.html')){
    event.respondWith(
      fetch(req).then(res => {
        if(res && res.ok){
          const copy = res.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(req, copy));
        }
        return res;
      }).catch(() => caches.match(req, { ignoreSearch: true }))
    );
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

/* ============ v3.14 : synchronisation et notifications (PWABuilder) ============
   - Periodic Background Sync (« refresh-shell ») : quand l'appli est installée
     et que le navigateur l'autorise (Chrome/Edge Android et ordinateur), la
     coquille (pages, icônes, mentions légales) est remise à jour en arrière-
     plan, environ une fois par jour, pour s'ouvrir à jour même hors ligne.
   - Background Sync (« refresh-shell ») : si la mise à jour échoue faute de
     réseau, le navigateur la relance tout seul dès le retour de la connexion.
   - Push : affiche les notifications envoyées à l'appli (titre, texte, lien).
     Margo et Bourgou n'ont pas de serveur d'envoi : rien n'est envoyé tant
     qu'un service de notifications n'est pas branché ; le gestionnaire est
     prêt pour ce jour-là. */
async function refreshShell(){
  const cache = await caches.open(CACHE_NAME);
  await Promise.all(CORE_ASSETS.map(async url => {
    const res = await fetch(url, { cache: 'no-store' });
    if(res && res.ok) await cache.put(url, res);
  }));
}

self.addEventListener('periodicsync', event => {
  if(event.tag === 'refresh-shell') event.waitUntil(refreshShell().catch(err => console.warn('SW periodic sync', err)));
});

self.addEventListener('sync', event => {
  // En cas d'échec (hors ligne), on relance l'erreur : le navigateur
  // retentera la synchronisation plus tard.
  if(event.tag === 'refresh-shell') event.waitUntil(refreshShell());
});

self.addEventListener('push', event => {
  let data = {};
  try{ data = event.data ? event.data.json() : {}; }
  catch(err){ data = { body: event.data ? event.data.text() : '' }; }
  const isBourgou = (data.app || '').toLowerCase() === 'bourgou';
  const title = data.title || (isBourgou ? 'Bourgou' : 'Margo');
  event.waitUntil(self.registration.showNotification(title, {
    body: data.body || 'Nouveautés pour votre prochain voyage.',
    icon: isBourgou ? './assets/icons/bourgou-192.png' : './assets/icons/icon-192.png',
    badge: isBourgou ? './assets/icons/bourgou-192.png' : './assets/icons/icon-192-maskable.png',
    data: { url: data.url || (isBourgou ? './bourgo.html' : './margo.html') },
    lang: 'fr'
  }));
});

self.addEventListener('notificationclick', event => {
  event.notification.close();
  const target = new URL((event.notification.data && event.notification.data.url) || './margo.html', self.registration.scope).href;
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then(list => {
      const open = list.find(c => c.url === target);
      return open ? open.focus() : self.clients.openWindow(target);
    })
  );
});
