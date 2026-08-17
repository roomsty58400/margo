# Margo — Générateur d'itinéraire touristique

**Margo** est une application web (une seule page HTML, sans installation ni base de données) qui génère un itinéraire touristique sur-mesure autour d'un lieu de départ : elle propose des lieux à visiter par catégorie, permet de composer un parcours, l'optimise selon le mode de transport choisi, puis produit un guide final imprimable avec cartes, QR codes et liens Google Maps.

## Fonctionnement en 3 écrans

1. **Lieu & sélection** — L'utilisateur saisit une ville (avec autocomplétion) et un rayon de recherche, puis choisit des catégories de lieux autour d'une fleur interactive (musées, sites historiques, cinémas, théâtres, restaurants, hôtels, gîtes, offices de tourisme...). Les lieux correspondants s'affichent sur une carte et dans une liste à cocher.
2. **Roadbook** — L'utilisateur choisit le mode de transport (marche, vélo, voiture, transport en commun) et ajuste le point de départ et d'arrivée directement dans la liste des étapes. L'itinéraire est calculé et prévisualisé sur une carte, avec possibilité de réordonner les étapes manuellement (glisser-déposer) ou d'ajouter un lieu directement trouvé sur la carte.
3. **Guide** — Le guide final est généré : une carte par mini-parcours (Google Maps limite un itinéraire à 10 étapes, l'appli découpe donc automatiquement au-delà), une fiche par étape (adresse, horaires, prix, téléphone, site web, photo), un lien "Ouvrir dans Maps" et un QR code pour l'ouvrir directement sur mobile. Le guide peut être imprimé, exporté en HTML ou Markdown, ou partagé par SMS / WhatsApp / email.

## Fonctionnalités notables

- **Deux modes de données** : mode démo (données générées localement, aucune clé requise) ou mode données réelles via l'API Google Places/Maps (nécessite une clé API, voir ci-dessous).
- **Cartes interactives** (Google Maps si une clé est configurée) avec tracé réel de l'itinéraire (Directions API), flèches de sens de parcours, et pins départ/arrivée mis en valeur.
- **🐌 Suggestion d'itinéraire local** : un bouton propose un itinéraire pensé par un office de tourisme partenaire proche, ou à défaut recherche l'office de tourisme réel le plus proche (Google Places puis repli gratuit OpenStreetMap/Overpass).
- **🔌 Bornes de recharge électrique** : affiche une carte des bornes à proximité (Open Charge Map) directement dans l'application.
- **Multilingue** : traduction du site via un sélecteur de langue (widget Google Traduction piloté par un menu déroulant maison).
- **RGPD / mentions légales** : page dédiée (`pages/mentions-legales.html`) accessible depuis le pied de page.
- **🎤 Salles de concert, ⚡ Bornes électriques, 🎬 Cinémas, 🎟️ Théâtres, 🏡 Gîtes & Airbnb** et de nombreuses autres catégories de lieux, sélectionnables directement sur la fleur.
- **🔄 Convertisseur Google Maps → Waze** et bouton Waze par étape dans le guide (Waze ne gère qu'une seule destination à la fois, contrairement à Google Maps).
- **Suggestions "à proximité"** dans le guide : complète l'itinéraire avec des lieux trouvés mais pas encore ajoutés, à moins d'1 km d'une étape existante.
- **🎤 Commande vocale** : dicter la ville de départ et les catégories à cocher (ex. *"je pars de Nevers avec des musées et des restaurants"*) via le bouton micro à côté du champ Ville. Basé sur la reconnaissance vocale native du navigateur (Web Speech API) : aucune clé ni service tiers, le bouton n'apparaît que si le navigateur la supporte (Chrome, Edge, Safari récents — pas Firefox).

## Lancer l'application en local

1. Double-clique sur `lancer-app.bat` (Windows). Le script démarre un petit serveur local (`python -m http.server`) et ouvre `margo.html` dans le navigateur.
2. Sans clé API : l'application fonctionne directement en **mode démo**.
3. Pour activer les données réelles Google : clique sur le bouton 🔑 en haut de la fleur, ou place une clé dans un fichier `apiki.env` à la racine du dossier (chargée automatiquement au démarrage). La clé doit avoir accès à **Maps JavaScript API**, **Places API (New)** et **Geocoding API**, et être restreinte par référent HTTP dans Google Cloud Console.

## Installer Margo comme une appli sur smartphone (PWA)

Margo est une **Progressive Web App** : pas besoin de fichier `.apk`, elle s'installe directement depuis le navigateur et s'ouvre ensuite en plein écran, avec sa propre icône sur l'écran d'accueil.

Condition : le site doit être servi via une URL `http://` ou `https://` (via `lancer-app.bat` en local, ou une fois hébergé en ligne — par exemple avec GitHub Pages sur ce dépôt). Une simple ouverture du fichier `margo.html` en double-clic (`file://`) ne permet pas l'installation.

- **Android (Chrome)** : ouvrir le site → menu ⋮ → *Installer l'application* (ou un bandeau "Ajouter à l'écran d'accueil" apparaît automatiquement).
- **iPhone/iPad (Safari)** : ouvrir le site → bouton Partager → *Sur l'écran d'accueil*.
- **Ordinateur (Chrome/Edge)** : icône d'installation ⊕ dans la barre d'adresse.

Une fois installée, l'interface de l'appli (mais pas les données live comme les résultats Google Maps) reste accessible même sans réseau, grâce au service worker (`sw.js`).

## Hébergement public (GitHub Pages)

`index.html` redirige automatiquement vers `margo.html` : une fois GitHub Pages activé sur le dépôt, l'URL racine fonctionne directement. Une fois en ligne, le site sera accessible à `https://roomsty58400.github.io/margo/`.

Pour activer GitHub Pages (à faire une seule fois, sur github.com) :
1. Va sur le dépôt → onglet **Settings** → section **Pages** (menu de gauche).
2. Sous *Build and deployment* → *Source*, choisis **Deploy from a branch**.
3. Branche : **main**, dossier : **/ (root)** → **Save**.
4. Attends 1 à 2 minutes, puis ouvre `https://roomsty58400.github.io/margo/`.

## Structure du dossier

```
generateurititourist/
├── margo.html                   L'application complète (HTML + CSS + JS en un seul fichier)
├── index.html                   Redirige vers margo.html (pour l'URL racine sur GitHub Pages)
├── manifest.json, sw.js         Fichiers PWA (installation écran d'accueil, usage hors-ligne)
├── lancer-app.bat               Lance un serveur local et ouvre l'application
├── publier-github.bat           Publie les changements sur le dépôt GitHub
├── apiki.env  (non versionné)   Clé API Google Maps, chargée automatiquement si présente
├── README.md, .gitignore
├── assets/
│   ├── images/                  margo-logo.png, margo.png, snail-route.gif
│   └── icons/                   margo.ico, icon-192*.png, icon-512*.png, apple-touch-icon.png
├── pages/
│   └── mentions-legales.html    Mentions légales / RGPD / cookies
└── archives/  (non versionné)   Sauvegardes locales
```

| Emplacement | Rôle |
|---|---|
| `margo.html` | L'application complète (HTML + CSS + JS en un seul fichier) |
| `index.html` | Redirige vers `margo.html` (pour l'URL racine sur GitHub Pages) |
| `pages/mentions-legales.html` | Page mentions légales / RGPD / cookies |
| `assets/images/` | Logo (`margo-logo.png`, `margo.png`) et animation d'en-tête (`snail-route.gif`) |
| `assets/icons/` | Favicon et icônes PWA (`margo.ico`, `icon-192*.png`, `icon-512*.png`, `apple-touch-icon.png`) |
| `manifest.json`, `sw.js` | Fichiers PWA (installation sur écran d'accueil, usage hors-ligne) |
| `lancer-app.bat` | Lance un serveur local et ouvre l'application |
| `publier-github.bat` | Publie les changements sur le dépôt GitHub |
| `apiki.env` *(non versionné)* | Clé API Google Maps, chargée automatiquement si présente |

## Historique des versions

*Numérotation introduite rétroactivement pour regrouper les évolutions du projet ; les versions les plus anciennes n'ont pas de date précise faute d'historique Git détaillé.*

### v2.80 — Nouvelles catégories : Cinémas, Théâtres, Gîtes & Airbnb ; retrait de Golfs
- Ajout de 3 catégories dans le groupe Loisirs & sport / Hébergement : 🎬 Cinémas (type Google `movie_theater`), 🎟️ Théâtres (type Google `performing_arts_theater`) et 🏡 Gîtes & Airbnb (pas de type Google dédié aux locations entre particuliers, repli sur `cottage`, même logique que "Bureaux de tabac" → `convenience_store`). Mots-clés de commande vocale, données de démonstration et générateur de noms mis à jour en conséquence ; "théâtre"/"spectacle" retirés des mots-clés de "Sites culturels" pour éviter un double déclenchement avec la nouvelle catégorie Théâtres.
- Retrait complet de la catégorie ⛳ Golfs (définition, mapping Google Places, mots-clés vocaux, lieux de démonstration Paris/Bourges, générateur de noms).

### v2.79 — Sous-catégories : pastilles et pictogrammes agrandis, badge repositionné
- Pastille de compteur (nombre de lieux trouvés) sur chaque carte de sous-catégorie : agrandie et repositionnée à l'intérieur du coin haut-droit de la carte (au lieu de déborder au-dessus), pour ne plus jamais être rognée par `overflow:hidden`.
- Pictogrammes agrandis dans les onglets de catégorie et les cartes de sous-catégorie, pour un rendu plus lisible.

### v2.78 — Redesign esthétique des 4 boutons de coin + cœur de la fleur
- Les 4 boutons de coin (🔌🐌🚑🔧) partagent désormais une base commune factorisée (dégradé à deux tons, ombre en double couche, anneau intérieur blanc, icône mieux proportionnée) au lieu d'un simple cercle blanc cerné de vert.
- Cœur de la fleur (cadre "Lieu de départ") : halo à trois anneaux, dégradé radial avec reflet, badge 📍 affiné, champ ville avec ombre interne subtile — même position et proportions, rendu plus travaillé.
- Cadre fleur + 4 boutons légèrement réduit (480px → 428px) et boutons rapprochés du centre, pour libérer un peu de hauteur au profit du panneau de sous-catégories.

### v2.77 — Carte : grand cadre centré verticalement dans sa colonne
- Le cadre de la carte (colonne de droite) garde désormais une proportion fixe et se centre verticalement dans sa colonne, avec une marge identique en haut et en bas entre la bannière et le carrousel, au lieu de s'étirer systématiquement sur toute la hauteur disponible.

### v2.76 — Bouton "Coups de cœur Office de Tourisme" déplacé + retrait "Tout déplier"/"Tout replier"
- Les boutons "▾ Tout déplier" / "▸ Tout replier" (colonne résultats) sont supprimés (redondants avec le caret de chaque branche de la liste).
- Le bouton "🛎️ Coups de cœur Office de Tourisme" est déplacé directement à droite du titre "Lieux à visiter" dans l'arborescence des résultats, au lieu d'une barre d'outils séparée au-dessus de la liste.
- Titre "Lieux trouvés autour de…" et bouton "Relancer la recherche" masqués dans la colonne résultats (redondants avec les contrôles déjà présents ailleurs sur l'écran).

### v2.75 — Scroll de la colonne résultats confiné à la seule liste de lieux + site web injoignable masqué
- Dans la colonne de gauche (écran Lieu & sélection), seule la liste des lieux trouvés (`#resultsContainer`) défile désormais en interne ; le titre, le rayon, les boutons et le bandeau "lieu(x) sélectionné(s) + Générer le ROADBOOK" restent fixes en haut/bas de la colonne au lieu de défiler avec la liste.
- Vérification des sites internet proposés (voir v2.4) : quand un site ne répond pas, la ligne "Site internet" correspondante est maintenant entièrement masquée plutôt qu'affichée barrée avec une icône ⚠️ — aucune information tronquée ou invalide n'est plus affichée à l'utilisateur.

### v2.74 — Refonte complète de l'écran "Lieu & sélection" : fin des chevauchements avec le carrousel
- **Cause racine identifiée** : le carrousel des offices de tourisme partenaires, en bas d'écran, était en `position:fixed` — donc totalement hors du flux normal de la page. Rien dans la mise en page ne "savait" qu'il fallait lui laisser de la place : sa position devait être devinée en JS à chaque changement de contenu (recherche, dépliage de catégories...), d'où des chevauchements récurrents avec les 3 colonnes malgré plusieurs correctifs ciblés successifs (marges fixes, `calc(100vh - Npx)`, variable de "zone sûre" recalculée en JS).
- **Nouvelle approche, fiable par construction** : pendant que cet écran est actif, `<body>` devient une colonne flex qui occupe exactement la hauteur de l'écran (bannière, stepper, contenu 3 colonnes, carrousel — chacun sa rangée). Le carrousel redevient une rangée normale de ce flux, plus jamais en `position:fixed` : la mise en page elle-même lui réserve sa place, sans plus aucun calcul de "zone sûre" en JavaScript.
- Résultat : plus de scrollbar de page, plus de chevauchement carrousel/colonnes, la fleur et ses 4 boutons de coin ne bougent jamais. Le panneau de sous-catégories se réduit visuellement (`transform:scale`) plutôt que de déborder ou de créer son propre ascenseur, si le contenu dépasse l'espace disponible.

### v2.5 — Formulaire & pétales de coin
- Cadre placeholder "Renseigne un lieu de départ…" restylé aux couleurs du site (texte en vert/bleu foncé au lieu du gris neutre) ; bouton 🔍 Recherche transformé en bouton façon chenille-pétale (même silhouette bombée + antenne + pattes pointillées que les autres boutons du site).
- Le formulaire (ville, catégories, résultats, fleur) se réinitialise automatiquement au rechargement de la page et à chaque clic sur le bouton Accueil, au lieu de garder la recherche précédente.
- Les 4 boutons de coin de la fleur (⚡ bornes, 🐌 escargot, 🚑 urgences, 🔧 dépannage) sont visibles dès le démarrage sous forme de 4 coccinelles (corps rouge tacheté + tête + antennes) ; dès qu'une ville/adresse de départ est renseignée (même signal que l'ouverture des pétales), la coccinelle s'efface et laisse place au bouton pétale avec son pictogramme habituel.
- Bouton commande vocale 🎤 déplacé sous le champ Pays dans le cœur de la fleur (au lieu d'être collé au champ Ville).

### v2.6 — Popup GPS & bandeau guide
- Popup "Ouvrir avec…" du guide : vrais logos officiels pour Google Maps, Waze et OsmAnd (source Simple Icons, licence CC0, embarqués en SVG hors-ligne) à la place des emojis. Mappy et Coyote gardent des icônes génériques (pin / patte) faute de logo officiel accessible depuis l'environnement de génération — à remplacer si vous fournissez les vrais fichiers de logo.
- Bandeau d'en-tête du guide : retrait des pills "Marche (…km/h)" et "Rayon de recherche : …km" (gardés : "Optimisé par" et "Durée estimée totale").

### v2.7 — Nettoyage bandeau d'actions du guide
- Masquage des boutons ← Retour, ⬇️ Markdown et 🔄 Recommencer dans le bandeau d'actions du guide (gardés dans le code, juste `hidden`, au cas où il faille les remettre).

### v2.8 — Picto commande vocale
- Bouton de commande vocale : gros escargot 🐌 portant un micro 🎤 (superposé), agrandi, à la place du simple picto micro.

### v2.9 — Bouton traduction agrandi + label fleur
- Bouton de sélection de langue (bannière) agrandi à ~55px de haut (3/5 de la hauteur de la bannière) : drapeau, texte et flèche redimensionnés en proportion.
- Texte "Lieu de départ" dans le cœur de la fleur agrandi.

### v2.10 — Nettoyage liste résultats
- Suppression du cadre "📌 Autres lieux ajoutés" dans l'arborescence des résultats (les lieux concernés restent accessibles depuis la carte).

### v2.11 — Correctif régression : positionnement carte & suggestions ville
- **Bug corrigé** : la carte se positionnait parfois "trop loin" (jusqu'à ~230km) après avoir saisi une ville. Cause : `geocodeCityFree()` retombait silencieusement sur Paris à chaque échec Nominatim, ce qui arrivait souvent car Nominatim limite à 1 requête/seconde et l'autocomplétion l'interroge aussi en parallèle pendant la frappe (429 fréquent). Corrigé : une tentative supplémentaire avant d'abandonner, et surtout plus de saut silencieux vers Paris — la dernière position connue est conservée à la place.
- Nevers ajouté à la table des centres-villes connus (coordonnées vérifiées), pour ne plus du tout dépendre du réseau sur cette ville.
- Suggestions d'autocomplétion ville/adresse : liste moins encombrée de quasi-doublons ("rue X, Ville" répété plusieurs fois) — les suggestions "ville seule" apparaissent maintenant en premier, suivies d'au plus 3 adresses précises, sur un total de 5 résultats Nominatim au lieu de 7 mélangés.

### v2.12 — Bouton "Autre appli" + fix index.html
- Le bouton "🔄 Lien Maps → Waze" du guide est remplacé par "🗺️ Autre appli", qui ouvre le même sélecteur d'appli GPS (Waze/Google Maps/Mappy/OsmAnd/Coyote) que par étape, mais pour l'itinéraire complet : Google Maps reçoit le vrai lien multi-étapes, les autres applis ciblent la destination finale géocodée précisément.
- **Bug corrigé** : `index.html` contenait des marqueurs de conflit Git non résolus (`<<<<<<< HEAD` / `=======` / `>>>>>>>`), qui cassaient la redirection vers `margo.html`. Résolu (conservé la version en chemin relatif, compatible sous-dossier type GitHub Pages).

### v2.13 — Carrousel OT façon chenille
- Badges du carrousel "Offices de Tourisme partenaires" (bas d'écran) restylés façon chenille (silhouette bombée + antenne + pattes pointillées, couleur reprise de chaque partenaire), pour rester cohérent avec le reste du site.
- Forme optimisée pour un badge large (côtés pleinement arrondis, ondulation organique réservée au bas) et intérieur rempli avec la couleur propre à chaque office (au lieu d'un simple contour), reflet radial clair en surimpression pour le volume.

### v2.14 — Nettoyage écran Options / Roadbook
- Bouton "Générer le guide" déplacé juste sous le champ Point d'arrivée (au lieu d'être sous la carte d'aperçu).
- Suppression du cadre "Mini-parcours — Ouvrir dans Google Maps" + QR + bouton "← Retour" sous la carte d'aperçu (navigation déjà possible via le stepper cliquable).
- L'étape 2 du stepper s'appelle désormais "Roadbook" au lieu de "Options".

### v2.15 — Nouvelles catégories
- Ajout de 3 catégories : ⛽ Stations-service, 🚬 Bureaux de tabac, 🏦 Banques (fleur, recherche réelle, mode démo, commande vocale). Côté Google Places, "essence" → `gas_station` et "banque" → `bank` (types officiels) ; "tabac" n'a pas de type Google dédié, repli sur `convenience_store` (le plus proche disponible).

### v2.16 — Fix flèches de direction
- **Bug corrigé** : les flèches de sens de parcours sur la carte d'aperçu d'itinéraire pouvaient pointer à l'inverse du trajet réel (surtout visible après changement du point de départ). Cause : mauvaise constante Google Maps (`BACKWARD_CLOSED_ARROW` au lieu de `FORWARD_CLOSED_ARROW`).

### v2.17 — Fix glisser-déposer tactile
- **Bug corrigé** : le glisser-déposer des étapes (écran Roadbook) ne fonctionnait pas du tout sur mobile/tablette (le drag-and-drop HTML5 natif ne se déclenche pas sur la plupart des navigateurs tactiles), ce qui laissait le bouton "↺ Revenir à l'ordre optimisé" bloqué indéfiniment puisque l'ordre manuel n'était jamais enregistré. Ajout d'une implémentation tactile équivalente sur la poignée ⠿.

### v2.18 — ROADBOOK
- Titre "Aperçu de l'itinéraire" renommé "🗺️ ROADBOOK".
- Les 3 pills (mode de transport, durée du trajet, distance totale) déplacées au-dessus de la carte (au lieu d'être au-dessus de la liste des étapes).

### v2.19 — Nettoyage doublon départ/arrivée
- Retrait des badges colorés "🚩 Point de départ" / "🏁 Point d'arrivée" au-dessus des champs (réglages) : ils faisaient doublon avec les pastilles de même couleur déjà affichées dans la liste des étapes du Roadbook. Le picto reste visible via le placeholder du champ.

### v2.20 — Bouton Générer sous l'étape d'arrivée
- Bouton "Générer le guide" déplacé du panneau de réglages vers la liste des étapes, directement sous le pin d'arrivée orange (pleine largeur).

### v2.21 — Moyen de transport au-dessus du Roadbook
- Bloc "🧭 Moyen de transport" (Marche/Vélo/Voiture/Transport en commun) déplacé du panneau de réglages vers la colonne ROADBOOK, juste sous le titre et au-dessus des pills + de la carte.

### v2.22 — Pins départ/arrivée éditables
- Les pastilles 🚩/🏁 de départ et d'arrivée, dans la liste des étapes du Roadbook, sont maintenant directement modifiables (au lieu d'un simple texte) — synchronisées avec les champs du panneau de réglages, avec anti-rebond pour ne pas perdre le focus pendant la frappe.

### v2.69 — Audit approfondi : XSS, désync curseurs de rayon, a11y
- **Sécurité (XSS)** : `buildPoiPopupHtml()` (bulle de survol des pins sur la carte des résultats) insérait `poi.name`/`poi.addr`/`poi.photoUrl` sans `escapeHtml()`, contrairement à ses deux fonctions jumelles (`buildItineraryAddPopupHtml`, `buildGuidePinPopupHtml`) déjà protégées — corrigé. `partnerBadgeHtml()` échappe désormais aussi `name`/`url`/`color` par cohérence (données actuellement en dur, sans risque réel, mais aligné sur le reste du code).
- **Bug fonctionnel** : les deux curseurs de rayon de recherche (`radiusSlider` dans la fleur, `radiusSlider2` dans les résultats) pilotaient la même valeur mais avec des handlers divergents — bouger celui de la fleur ne rafraîchissait ni les résultats ni la carte, et aucun des deux ne resynchronisait l'autre curseur. Unifiés en un seul `handleRadiusChange()` partagé qui met à jour l'état, les deux curseurs/labels et le rendu (résultats + carte + compteurs de sous-catégories).
- **Cohérence liens externes** : `rel="noopener noreferrer"` uniformisé sur tous les liens `target="_blank"` (5 endroits utilisaient seulement `noopener`).
- **Accessibilité** : ajout d'un vrai `<label for="inputVille">` (au lieu d'un simple `<strong>` non lié) pour le champ Ville, `for=` sur les labels des deux curseurs de rayon, et `aria-label` sur les champs Code postal, Pays, clé API et lien Waze à convertir (aucun n'avait de label programmatiquement associé).
- **Non appliqué, signalé pour suite** : code mort lié à l'ancien moteur Leaflet (`ensureLeafletLoaded`, `leafletColoredIcon`, `addPartnerMarkersToMap`, branches `mapMarkerKind==='leaflet'`) — nécessite une vérification plus poussée avant suppression car une carte Leaflet distincte (aperçu France des offices de tourisme partenaires) semble toujours active ; `renderGuide()` reconstruit toutes les cartes Google de tous les mini-parcours à chaque petite modification (glisser-déposer, ajout/retrait d'étape) au lieu de ne recalculer que celui concerné — optimisation possible mais plus invasive.

### v2.68 — Bug fix : compteur de sélection pas remis à 0 au reload/Accueil
- `resetForm()` (appelée au chargement de la page et au clic sur Accueil) vidait bien `state.selectedIds`, mais n'appelait jamais `updateSelCount()` : le cadre "X lieu(x) sélectionné(s) + Générer le ROADBOOK" gardait donc affiché le compteur et la visibilité de la sélection de la session précédente jusqu'au prochain clic sur une case à cocher.
- Ajout de l'appel à `updateSelCount()` dans `resetForm()` : le compteur repasse à "0 lieu sélectionné" et le cadre se recache immédiatement au rechargement de la page ou au clic sur Accueil.

### v2.67 — Bug fix : liste compacte du Guide non glissable-déposable
- Dans la liste compacte des étapes affichée à côté de la carte du Guide (`.order-list`, ajoutée en v_113), les `<li>` de chaque lieu n'avaient ni `data-id` ni `draggable="true"` : le CSS de survol pendant le glisser (`.dragging`/`.drag-over`) existait déjà mais rien ne pouvait jamais le déclencher — impossible de réordonner les étapes en les glissant depuis cette liste.
- Ajout d'une poignée ⠿ + `data-id`/`draggable="true"` sur ces `<li>`, et généralisation des listeners `#guideContent` (jusqu'ici ciblés uniquement sur les grandes cartes `.step`) à une classe partagée `.draggable-step`, présente à la fois sur `.order-list li` et `.step` — le glisser-déposer fonctionne maintenant sur les deux présentations des étapes (liste compacte et cartes détaillées), souris comme tactile.

### v2.66 — Bug fix : alignFlowerColumnBottom ne corrigeait qu'un sens
- `alignFlowerColumnBottom()` (v2.64) ne décalait la colonne fleur que si elle était PLUS HAUTE que la carte (margin-top négatif). Or la carte a une hauteur fixe (~620px) presque toujours supérieure à celle de la colonne fleur — donc ce cas se déclenchait rarement et le décalage restait invisible, d'où le problème signalé à nouveau par l'utilisateur.
- Correction : le décalage s'applique désormais dans les deux sens (margin-top positif pour descendre la colonne fleur si elle est plus courte que la carte, négatif si elle est plus haute) — le bas du panneau de sous-catégories s'aligne bien sur le bas du cadre carte dans tous les cas.

### v2.65 — Cadre "lieux sélectionnés + Générer le ROADBOOK" collé en bas
- `.sticky-footer` (compteur de sélection + bouton Générer le ROADBOOK) passe en `position:sticky;bottom:0` à l'intérieur de la colonne de résultats (qui défile en interne). Il reste ainsi toujours visible en bas du cadre, à hauteur du bas du panneau de sous-catégories de la colonne fleur, au lieu de défiler avec la liste des résultats.
- Sans effet sous le breakpoint mobile/tablette (la colonne de résultats redevient `position:static`/`overflow-y:visible`, le bandeau reste simplement en flux normal).

### v2.64 — Alignement dynamique du bas de la colonne fleur sur le bas de la carte
- Ajout de `alignFlowerColumnBottom()` : remonte (marge haute négative) l'ensemble de la colonne centrale (boutons de coin + fleur + onglets + panneau de sous-catégories) quand elle dépasse en hauteur le cadre carte de la colonne de droite, pour que le bas du panneau de sous-catégories s'aligne sur le bas du cadre carte.
- Calcul dynamique (mesure réelle des deux colonnes), pas une valeur fixe : la hauteur de la colonne fleur varie selon le nombre de sous-catégories affichées et la largeur d'écran (retour à la ligne des onglets/cartes). Recalculé à l'ouverture/fermeture d'un groupe de catégories, au redimensionnement de la fenêtre, et au retour sur l'écran Lieu.
- Ne s'applique qu'au layout desktop 3 colonnes (`.lieu-col-flower` en `position:sticky`) ; sous le breakpoint mobile/tablette, où les colonnes s'empilent, cet alignement n'a pas de sens et n'est pas appliqué.
- Ne remonte que si la colonne fleur dépasse effectivement la carte (jamais de décalage vers le bas) — si un groupe de catégories est refermé et que la colonne redevient plus courte que la carte, l'ajustement est retiré automatiquement.

### v2.63 — Boutons de coin encore rapprochés du centre
- Insets des 4 boutons de coin resserrés de 5% à 9% (taille inchangée, 20%) — marge de sécurité vérifiée avec le cœur de la fleur (cercle de 37%) pour qu'ils ne se chevauchent jamais.

### v2.62 — Compteur de sélection et bouton "Générer le ROADBOOK" sur la même ligne
- Le bandeau `#selFooter` passe d'un empilement vertical (`<br><br>`) à une ligne flex (compteur + bouton côte à côte, centrés, avec repli automatique en colonne si la largeur manque — mobile étroit ou libellé du compteur plus long).

### v2.61 — Boutons de coin +25% et rapprochés du centre
- Les 4 boutons de coin (🔌🐌🚑🔧) agrandis de 25% (16% → 20% du cadre, min-width 44→55px, max-width 60→75px, icône 1.7→2.1rem) et rapprochés du centre de la fleur (insets 2% → 5%).
- **Rappel** (déjà signalé au tour précédent) : ces boutons sont en `position:absolute`, donc ils ne consomment aucune hauteur dans la mise en page — les agrandir/rapprocher n'a pas d'effet sur la hauteur totale de la colonne fleur ni sur le risque de scroll de page. Ce qui a réellement rapproché les sous-catégories du bas du cadre carte, c'est le déplacement du bandeau de sélection hors de cette colonne (v2.59) et les resserrages précédents (v2.55) — avec la fleur maintenue à 480px, la colonne fleur (flower + onglets + panneau déplié) est déjà proche en hauteur du cadre carte (~620px).

### v2.60 — Retrait de l'effet "coccinelle" sur les 4 boutons de coin
- Les 4 boutons de coin de la fleur (🔌 bornes, 🐌 escargot, 🚑 urgences, 🔧 dépannage) affichent désormais directement leur pictogramme réel en permanence, au lieu de se présenter comme des coccinelles (corps rouge tacheté + tête + antennes) tant que le lieu de départ n'est pas renseigné. Retrait des pseudo-éléments `::before`/`::after` qui dessinaient cet effet ; la classe `.corner-btns-hidden` reste posée/retirée par le code existant mais n'a plus d'effet visuel ici.

### v2.59 — Bandeau "sélection + Générer le ROADBOOK" déplacé sous les résultats
- Le bandeau `#selFooter` (nombre de lieux sélectionnés + bouton "Générer le ROADBOOK →"), auparavant sous la fleur (colonne centrale), est déplacé sous le cadre de résultats de la colonne de gauche. Comportement inchangé (masqué tant qu'aucun lieu n'est sélectionné), seule sa position dans la page change.

### v2.58 — Suppression du défilement interne de la bulle d'infos
- Retrait de `max-height:220px` + `overflow-y:auto` sur `.info-details` : la bulle n'a plus sa propre barre de scroll, elle s'affiche désormais en entier quelle que soit la longueur du contenu (la marge basse du cadre résultats, voir v2.57, reste là pour éviter qu'elle soit tronquée par le bord du cadre).

### v2.57 — Marge basse dans le cadre résultats pour ne plus tronquer la bulle d'infos
- La colonne de gauche (résultats) défile elle-même (`overflow-y:auto`) : pour un résultat proche du bas de la liste, la bulle d'infos au survol (voir v2.54) pouvait être coupée par le bord inférieur du cadre, faute de place pour scroller davantage et la révéler entièrement. Ajout d'une marge basse généreuse (240px, au moins la hauteur max de la bulle) sous la liste des résultats.

### v2.56 — ROADBOOK : fiche d'infos au survol des pins de la carte
- Sur la carte du Roadbook (mini-parcours), passer la souris sur un pin numéroté affiche désormais une fiche d'infos (comme les cartes de résultats de l'écran Lieu) : vignette photo, nom, bandeau "🛎️ Coup de cœur Office de Tourisme", adresse/distance, horaires (en liste jour par jour), tarif, moyens de paiement, téléphone et site web — au lieu du simple clic affichant juste "N. Nom du lieu". Un léger délai avant fermeture laisse le temps de cliquer un lien (site web) dans la fiche. Le clic garde le même effet, pour les appareils tactiles (pas de survol possible). Pins départ 🚩 et arrivée 🏁 gardent leur fiche simple (libellé texte).
- Mise en forme (icône+texte, horaires en liste) factorisée dans `buildPoiDetailsRowsHtml`, désormais partagée entre la bulle des cartes de résultats (v2.54) et cette nouvelle fiche du Roadbook — un seul endroit à maintenir pour ce format.

### v2.55 — Boutons de coin agrandis + resserrage vertical de la colonne fleur
- Les 4 boutons de coin (🔌 bornes, 🐌 escargot, 🚑 urgences, 🔧 dépannage) sont agrandis (13% → 16% du cadre, min-width 38→44px, max-width 52→60px, icône plus grande) et légèrement rapprochés du centre de la fleur (insets 2% au lieu d'être collés au bord exact du cadre).
- Espaces verticaux resserrés autour de la fleur pour remonter un peu les onglets de catégories et le panneau de sous-catégories : padding de `.flower-wrap` (1rem → .5rem), marge au-dessus du bandeau de sélection (`.sticky-footer`, 1.2rem → .6rem), marge/espacement du panneau de cartes sous-catégories (`.cat-chip-panel`).
- **Limite connue** : la fleur elle-même reste à 480px (taille gardée à la demande explicite du 04/08, cf. v2.44/correctif suivant) — c'est de loin le plus gros poste de hauteur de cette colonne. Sur un écran bas (petit laptop, fenêtre peu haute), il est possible qu'un panneau de sous-catégories déplié pousse encore la page à défiler entièrement, malgré ce resserrage. Réduire davantage nécessiterait de rétrécir la fleur elle-même, ce qui contredit la demande précédente — à confirmer avec l'utilisateur si le problème persiste à l'usage.

### v2.54 — Lisibilité du contenu de la bulle d'infos
- Horaires : au lieu d'un seul paragraphe dense ("lundi: 10:00–13:00, 14:00–18:00 · mardi: Fermé · mercredi: ... · dimanche: ..."), ré-affichés sous un petit intitulé "🕒 Horaires" avec une ligne par jour — nettement plus lisible d'un coup d'œil. Repli sur une simple ligne quand il n'y a qu'un seul segment (horaires "libres" du mode démo, ex. "Accueil : mar–ven 10h30–18h30").
- Chaque ligne (adresse, tarif, paiement, tél, site) passe d'un simple emoji collé au texte à deux colonnes (icône fixe + texte flexible) : un texte assez long pour passer à la ligne s'aligne maintenant sous lui-même plutôt que sous l'icône.
- L'adresse/les coordonnées sont désormais séparées du reste (horaires, tarif, paiement, tél, site) par une fine ligne pointillée, pour distinguer visuellement "où se trouve le lieu" du reste des informations pratiques.

### v2.53 — Bug corrigé (racine du grand écart) : .info s'étirait sur toute la hauteur de la vignette
- Trouvé la vraie cause du grand espace persistant malgré v2.51/v2.52 : `.tree-leaf` est un conteneur flex sans `align-items` déclaré, donc "stretch" par défaut — `.info` (qui n'a pas de hauteur propre) s'étirait sur toute la hauteur de la ligne (88px, celle de la vignette), même quand son contenu texte (titre + bandeau) n'en occupait qu'une petite partie en haut. La bulle (ancrée à `top:100%` de `.info`) apparaissait donc en bas de cette boîte étirée, loin sous le texte réel. Ajout de `align-self:flex-start` sur `.info` : elle ne prend maintenant que la hauteur de son propre contenu, quelle que soit la hauteur de la vignette à côté — la bulle s'ancre enfin juste sous le texte, quel que soit le nombre de lignes du titre.

### v2.52 — Bulle d'infos remontée (écart encore réduit)
- Toujours trop d'écart visuel entre le bandeau OT/titre et la bulle malgré le correctif v2.51 (2px) : marge repassée en négatif (-4px), la bulle chevauche légèrement l'espace de la marge basse du bandeau au lieu de s'en tenir à distance.

### v2.51 — Correctifs position (vraiment 2px) + largeur (vraiment celle du texte)
- **Bug corrigé (position)** : `.info` étant en flux normal, la marge basse du bandeau "Coup de cœur OT" sortait de sa boîte par collapsing de marge, ce qui décalait la bulle bien plus bas que les 2px prévus. `.info` passe en `display:flow-root`, qui inclut désormais cette marge dans sa propre hauteur — la bulle s'ancre enfin exactement à 2px du titre/bandeau.
- **Bug corrigé (largeur)** : `.info` n'ayant pas de `flex-grow` dans la ligne flex de la carte, elle restait aussi étroite que son texte (nom du lieu) au lieu de s'étendre jusqu'au bord droit de la carte — la bulle (calée sur cette largeur) était donc trop étroite. Ajout de `flex:1 1 auto` sur `.info` pour qu'elle occupe tout l'espace réservé au texte ; la largeur de la bulle (100% de `.info` moins 4px) est désormais correcte.

### v2.50 — Bulle d'infos rapprochée du bandeau OT
- Espace au-dessus de la bulle réduit au minimum (.35rem → 2px) pour qu'elle soit collée juste sous le bandeau "🛎️ Coup de cœur Office de Tourisme" (ou le titre si pas de bandeau).

### v2.49 — Largeur de la bulle d'infos alignée sur l'espace texte
- Largeur de la bulle (adresse, horaires, tarif, paiement, tél, site) recalée sur celle de l'espace texte (`.info`, la même largeur que le titre et le bandeau OT juste au-dessus) moins 4px, à la place d'une largeur fixe indépendante (260px) — la bulle épouse maintenant exactement la colonne du titre.

### v2.48 — Bulle d'infos : déclenchement sur la vignette + dimensions/position affinées
- La bulle de détails (adresse, horaires, tarif, paiement, tél, site — voir v2.47) s'affiche désormais aussi au survol de la vignette photo, pas seulement du texte du titre.
- Largeur fixe (260px, jusqu'à 320px sur grand écran) avec hauteur maximale et défilement interne si besoin, au lieu de s'étirer sur la largeur variable de la carte — cadre plus lisible et cohérent d'un résultat à l'autre.
- Position confirmée/verrouillée juste sous le titre et le bandeau "🛎️ Coup de cœur Office de Tourisme" (jamais superposée dessus).

### v2.47 — Cartes de résultats compactes : détails au survol
- Chaque carte de résultat (colonne de gauche) n'affiche plus en permanence que la vignette photo, le nom du lieu et le bandeau "🛎️ Coup de cœur Office de Tourisme" le cas échéant. Le reste des informations (adresse/coordonnées, horaires, tarif, moyens de paiement, téléphone, site web) est replié dans une bulle qui apparaît au survol du nom/texte de la carte (et au focus clavier, pour l'accessibilité), pour une liste plus compacte et lisible. La case à cocher et le clic sur la vignette gardent leur rôle habituel de sélection/désélection du lieu, inchangé.

### v2.46 — Masquage du bandeau de filtres catégories (colonne de gauche)
- Le bandeau de filtres catégories/sous-catégories (accordéon, `#catFilterBar`) dans la colonne de gauche est masqué : il faisait doublon avec le sélecteur onglets + cartes désormais sous la fleur (v2.44), seul point d'entrée pour cocher/décocher les catégories. La colonne de gauche n'affiche plus que le titre "Lieux trouvés autour de…" et la liste des résultats trouvés (masquage en CSS, gardé dans le code — `syncCategorySelectionUI`/`buildCatFilterBar` continuent de tourner en arrière-plan sans effet visuel).

### v2.45 — Masquage du bloc "Moyen de transport"
- Le bandeau des 4 modes de transport (🚶 Marche / 🚴 Vélo / 🚗 Voiture / 🚌 Transport en commun), en bas de l'écran Lieu au-dessus du bouton "Générer le ROADBOOK →", est masqué (`hidden`, gardé dans le code). Le mode par défaut (Marche) reste utilisé pour le calcul d'itinéraire, les liens GPS et l'export.
- **Bug corrigé** : l'attribut `hidden` seul ne suffisait pas à masquer ce bloc — une règle CSS auteur (`.radio-row{display:flex;...}`) l'emportait sur le `display:none` par défaut du navigateur (une règle d'auteur prime toujours sur le style par défaut du navigateur, même à spécificité égale), donc les 4 boutons restaient visibles malgré `hidden`. Ajout d'une règle explicite `.radio-row[hidden]{display:none;}` pour forcer le masquage.

### v2.44 — Sélecteur de catégories "onglets + cartes" (remplace les pétales-catégorie)
- Retour utilisateur sur la v2.43 ("me plaît moyennement, quelque chose de plus efficace et graphique ?") : l'anneau de 5 pétales-catégorie de la fleur (positionnement en coordonnées polaires, éventail de sous-pétales au clic) est remplacé par un sélecteur "onglets + cartes" — 5 onglets colorés et rectangulaires sous le cœur de la fleur (ville/pays, inchangé), qui dépliaient un panneau de cartes sous-catégories (icône, libellé, badge du nombre de lieux trouvés) juste en dessous au clic.
- Mise en page en grille flexible (flex-wrap) plutôt qu'un positionnement géométrique fixe : s'adapte nativement aussi bien au PC (onglets sur une ligne, cartes en ligne large) qu'au mobile/tablette (onglets qui passent à la ligne, cartes resserrées via une media query dédiée à 480px) avec un seul jeu de composants, sans dupliquer l'interface par taille d'écran.
- Bandeau de filtres (écran Résultats, accordéon par groupe) : puces légèrement agrandies et plus contrastées (padding, gras, ombre au survol) pour rester visuellement cohérentes avec les nouvelles cartes.
- Taille du cadre de la fleur (`.flower-frame`, cœur ville/pays + 4 boutons de coin) inchangée à 480px : un essai de réduction à 300px (l'anneau de pétales ayant disparu) a été testé puis annulé sur retour utilisateur — l'équilibre visuel avec le reste de l'écran était meilleur à la taille d'origine.
- Le mécanisme de verrouillage tant que la ville n'est pas renseignée (auparavant les pétales "en bourgeon") est conservé sous une autre forme : le sélecteur est grisé/non cliquable avec un message d'aide ("👆 Renseigne d'abord ton lieu de départ ci-dessus"), déverrouillé dès que l'adresse se géocode avec succès.

### v2.43 — Fleur et filtres en 6 catégories, pins colorés par catégorie
- Fleur (écran Lieu) : refonte pour réduire la surcharge visuelle (jusqu'à 19 pétales affichées en même temps auparavant). N'affiche plus par défaut que 5 pétales "catégorie" (Lieux à visiter, Loisirs & sport, Hébergement, Restauration, Services pratiques — mêmes 6 groupes/couleurs que le reste de l'app, le 6e "Autres lieux ajoutés" n'ayant pas de sous-catégories propres). Cliquer sur une catégorie déplie ses sous-catégories en éventail à côté d'elle, avec un badge indiquant le nombre de lieux trouvés pour chacune ; recliquer la referme. Un petit badge sur le pétale catégorie indique aussi combien de ses sous-catégories sont cochées, sans avoir à la déplier.
- Bandeau de filtres (écran Résultats) : même regroupement, sous forme d'accordéon (un groupe = une ligne dépliable, avec le nombre de catégories cochées dans le groupe), plutôt que les 19 puces à plat. La catégorie technique "Autres lieux ajoutés" reste une puce isolée, hors accordéon.
- Carte des lieux (écran Lieu) : chaque pin reprend désormais la couleur de sa catégorie (au lieu du bleu uniforme précédent) — cohérent avec les couleurs de la fleur et du bandeau de filtres. Un lieu sélectionné garde sa couleur de catégorie mais se distingue par un liseré rouge plus épais et un pin légèrement agrandi (au lieu de virer entièrement au rouge, ce qui aurait fait perdre le repère de catégorie).

### v2.42 — Bouton de traduction réduit de 25%
- Le bouton de traduction (bannière) était jugé trop imposant : taille réduite de 25% (hauteur, drapeau, texte, coins arrondis).

### v2.41 — Sécurité : blocage des redirections publicitaires depuis les cartes intégrées
- Les cartes Google Maps intégrées sans clé API (embed public, ex. "fr.parkindigo.com" signalé par un utilisateur) pouvaient contenir des bannières publicitaires tierces capables de rediriger ou ouvrir un nouvel onglet. Toutes les iframes de cartes (lieu, itinéraire, urgences, garages, bornes électriques, page d'accueil) sont maintenant sandboxées (pas de navigation top-level ni de popups autorisés depuis leur contenu) et n'envoient plus de referrer.

### v2.40 — Suppression de l'écran ROADBOOK intermédiaire (fusion Lieu → Guide)
- L'écran "Options"/Roadbook (aperçu + réglages avant génération) est supprimé : on passe désormais directement de ① Lieu à ② ROADBOOK (l'ancien écran "Guide", qui intègre déjà étapes glissables/éditables, cartes et départ/arrivée éditables depuis les évolutions précédentes).
- Le sélecteur de mode de transport (marche/vélo/voiture/TC) est déplacé dans l'écran Lieu, juste au-dessus du bouton "Générer le ROADBOOK →" (ex-"Continuer vers les options").
- Le stepper ne compte plus que 2 étapes : ① Lieu & sélection, ② ROADBOOK.
- Le titre "Itinéraire touristique" (bannière du guide, partage SMS/WhatsApp/Email, export Markdown) est renommé "ROADBOOK".
- Le badge "Ordre personnalisé" + bouton "Revenir à l'ordre optimisé" (perdus avec l'écran supprimé) sont réintégrés directement dans la bannière du ROADBOOK.

### v2.39 — Guide : pastilles départ/arrivée déplacées dans la colonne de gauche
- Les 2 pastilles éditables 🚩 Départ / 🏁 Arrivée, qui étaient dans la bannière du Guide, sont retirées de là et déplacées dans la colonne de gauche (liste compacte des étapes), à la place des 2 cadres colorés qui affichaient jusqu'ici le départ/arrivée en texte simple non modifiable — un seul emplacement éditable désormais, cohérent avec le Roadbook.

### v2.38 — Guide : réorganisation glissée, départ/arrivée éditables, doublon pays
- Guide : les étapes de chaque mini-parcours peuvent désormais être réordonnées par glisser-déposer (souris et tactile), comme dans le Roadbook — poignée ⠿ dédiée, même moteur de réordonnancement que le Roadbook.
- Guide : le point de départ et le point d'arrivée sont maintenant directement modifiables dans les pastilles 🚩/🏁 en haut du Guide (au lieu du Roadbook uniquement), avec anti-rebond pour ne pas perdre le focus pendant la frappe.
- Correction : quand le pays choisi apparaissait déjà dans l'adresse d'une étape ou dans le point de départ/arrivée, il pouvait s'afficher en double (ex. « ..., France, France »). Le doublon est maintenant automatiquement retiré, dans le Guide comme dans l'export Markdown.

### v2.37 — Refonte du GIF de la bannière (qualité)
- Le GIF (escargot-voiture + trajet en pointillés) réutilisait un sprite recadré depuis une très petite image d'origine : très pixelisé/crénelé une fois affiché à 2x la largeur, tirets gris ternes, courbe du trajet avec un coude disgracieux à l'étape intermédiaire. Entièrement redessiné en vectoriel (coquille en spirale, carrosserie, roues, antenne) avec anti-aliasing, tracé en vert de la marque (au lieu de gris) suivant une courbe lisse à tangente continue (sans coude) entre départ, étape intermédiaire et arrivée.

### v2.36 — Liste compacte des étapes à gauche de la carte (Guide)
- Chaque carte du Guide (une par mini-parcours) affiche désormais à sa gauche la même liste compacte d'étapes que le Roadbook (pastilles vertes/oranges départ-arrivée + numéros), pour garder ce repère visuel au lieu d'une carte isolée. Liste non éditable ici (contrairement au Roadbook), non imprimée (les fiches détaillées en dessous suffisent à l'impression). Empile en une seule colonne sur mobile/tablette.

### v2.35 — Tracé du trajet en vert dans le Roadbook
- La carte de l'aperçu itinéraire (écran Roadbook) traçait le trajet en bleu (`#3498db`) ; couleur alignée sur le vert de la marque (`#0d7a3a`, même couleur déjà utilisée sur la carte du Guide).

### v2.34 — Anneau intermédiaire des pétales décalé de 5px vers l'extérieur
- Les 9 pétales de l'anneau intérieur de la fleur sont décalées de 5px vers l'extérieur (à l'échelle de référence 480px). Marge anti-chevauchement revérifiée par simulation : reste positive sur tous les breakpoints.

### v2.33 — Escargot-micro réduit de 20%
- Bouton commande vocale (escargot 🐌 + micro 🎤) dans le cœur de la fleur : taille réduite de 20% (bouton, escargot et micro).

### v2.32 — Fix bug: lien Waze qui plante sans coordonnées
- Quand aucune coordonnée GPS n'est disponible pour une étape, le lien Waze combinait "nom du lieu, adresse" en une seule requête texte — ce mélange pouvait dérouter le moteur de recherche de Waze et faire échouer/planter l'ouverture de la navigation. Le lien utilise désormais l'adresse précise seule (le vrai repère géographique) quand elle est disponible, et ne retombe sur le nom du lieu que si aucune adresse fiable n'existe.

### v2.31 — Esthétique du badge "Ordre personnalisé" et du bouton "Revenir à l'ordre optimisé"
- Le badge "✋ Ordre personnalisé" utilisait la classe `.pill` sans jamais être dans `.summary-box` (seul contexte où `.pill` avait un style) : il s'affichait donc sans arrondi ni padding. Ajout d'un style `.pill` de base généralisé (réutilisable partout), plus une variante `.pill-accent` dédiée (dégradé orange, liseré clair, ombre teintée) pour ce badge.
- Le bouton "↺ Revenir à l'ordre optimisé" avait le style générique gris plat `.btn.secondary` : nouvelle variante `.btn-reset-order` (dégradé ardoise plus doux, liseré, icône qui pivote au survol pour renforcer l'idée de réinitialisation).

### v2.30 — Réorganisation de la barre de boutons du Roadbook
- Titre "🧭 Moyen de transport" retiré (redondant avec les pictos des boutons). Le sélecteur de mode de transport et le bouton "↺ Revenir à l'ordre optimisé" (avant généré tout en haut de la colonne des étapes, sans lien visuel avec le reste) partagent maintenant une seule barre d'outils, juste sous le titre ROADBOOK.

### v2.29 — Fix racine: pétales chevauchées à cause d'un nombre impair de catégories
- Cause réelle trouvée : il y a 19 catégories (nombre impair), et la répartition en quinconce par simple parité d'index global (v2.28) casse justement dans ce cas — le dernier pétale extérieur se retrouvait à seulement la moitié de l'écart angulaire prévu de son voisin (1 pas au lieu de 2), donc largement chevauché avec lui, même en plein écran. Remplacé par un algorithme où chaque anneau (extérieur/intérieur) reçoit sa propre répartition régulière sur 360°, calculée indépendamment de l'autre anneau — valable pour n'importe quel nombre de catégories, pair ou impair. Rayons et décalage angulaire choisis par simulation exhaustive : marge de sécurité positive vérifiée sur tous les breakpoints (270/360/480px) pour 16 à 22 catégories.

### v2.28 — Fix bug: pétales encore chevauchées sur petit écran
- Le correctif précédent (2 anneaux) était correct à taille normale mais recassait sous ~320px de large : le rayon de l'anneau (en %) rétrécit avec le conteneur, alors que le plancher `min-width/min-height` des pétales (58×52px, fixe) ne rétrécit pas — sur le plus petit breakpoint mobile (`.flower-frame` à 270px), les pétales redevenaient proportionnellement trop grosses pour leur anneau et se chevauchaient à nouveau (vérifié par calcul : marge de -8px à 270px). Plancher réduit à 40×36px, sous la taille naturelle même au plus petit breakpoint : il ne s'applique donc plus jamais en pratique, la mise à l'échelle reste proportionnelle à toutes les tailles d'écran.

### v2.27 — TomTom GO et Sygic dans "Ouvrir avec…"
- Deux applis ajoutées à la fleur de choix d'appli GPS (bouton "📱 Autre appli") : 🧭 TomTom GO (logo officiel, lien `tomtomgo://x-callback-url/navigate?destination=...`, schéma documenté par TomTom) et 🧭 Sygic (lien `com.sygic.aura://coordinate|...|drive`, schéma documenté par Sygic Developers). Les deux ouvrent directement l'appli si elle est installée sur le téléphone (sans effet sur ordinateur).
- Aucune source de logo officiel Sygic n'étant accessible depuis l'environnement de développement (pas dans simple-icons, pas de récupération d'asset tiers possible), une icône générique "navigation" est utilisée à la place, honnêtement marquée `official:false` dans le code — avec toutefois la vraie couleur de marque Sygic (#EC1B2E).

### v2.26 — Bannière : GIF escargot 2x plus large + étape intermédiaire
- Le GIF animé de la bannière (`assets/images/snail-route.gif`) est régénéré à partir de son propre sprite d'origine (même escargot-voiture, mêmes couleurs) : canevas doublé en largeur (440×84 au lieu de 220×84), ce qui double aussi sa largeur affichée (la hauteur CSS reste fixe, la largeur suit automatiquement le ratio). Le trajet comprend désormais une étape intermédiaire (petit marqueur vert) où l'escargot marque un arrêt avant de repartir vers la destination finale (pin orange, inchangé).

### v2.25 — Fix bug: boutons "Retour"/"Recommencer"/"Markdown" visibles malgré l'attribut hidden
- La règle CSS générique `.btn{display:inline-block}` avait la même priorité que l'attribut `hidden` et gagnait contre lui, rendant ces boutons visibles alors qu'ils étaient censés être masqués (même bug déjà rencontré et corrigé pour `#apiKeyTriggerBtn`). Ajout d'une règle `[hidden]{display:none!important;}` ciblée pour les trois boutons (Retour, Recommencer, Markdown).

### v2.24 — Fix bug: résultats hors-sujet dans une catégorie (ex. agence retraite en "Banques")
- Google classe parfois des agences administratives (conseil retraite, assurance...) sous le même type que les banques dans son propre annuaire, alors qu'elles n'ont aucun rapport avec le tourisme. Ajout d'un filtre côté appli : on ne garde un résultat que si le type exact renvoyé par Google correspond bien à la catégorie recherchée.

### v2.23 — Suppression du cadre de gauche (écran Roadbook)
- Le panneau de gauche de l'écran Roadbook est retiré : plus de sélecteur "🚶 Profil de marche" (lent/normal/rapide), plus de choix "🎯 Optimiser selon" (distance/durée), plus de champs Métadonnées (nom du projet, auteur, date). La colonne Roadbook (Moyen de transport + pastilles éditables + carte) occupe désormais toute la largeur.
- Conséquence assumée : la vitesse de marche reste fixée à 4,5 km/h et l'optimisation à "distance la plus courte" (valeurs par défaut), sans réglage possible dans l'UI ; les métadonnées du guide (projet/auteur/date) ne sont plus saisissables.
- Le départ et l'arrivée restent modifiables normalement via les pastilles 🚩/🏁 éditables de la liste des étapes (v2.22).

### v2.4 — Fiabilité guide & navigation
- Export HTML du guide : vraie miniature pour chaque étape (photo du lieu si disponible, sinon logo Margo en repli) au lieu du simple emoji d'avant.
- Vérification "au mieux" des sites internet proposés : badge ⚠️ si un site ne répond pas du tout, résultat mis en cache 7 jours.
- Correction : cliquer sur une adresse de la liste de résultats affiche aussi son pin sur la carte (avant, seul le survol à la souris fonctionnait — ne marchait donc pas au clic sur mobile/tablette).
- Popup "📍 Ouvrir avec…" par étape du guide : choix de l'appli de navigation (Waze, Google Maps, Mappy, OsmAnd, Coyote) sous forme de petite fleur de pétales.
- Correction de l'auto-remplissage du convertisseur Waze quand le lien Maps généré utilise un nom de lieu plutôt que des coordonnées.
- Stepper (Lieu & sélection / Options / Guide) : numéros agrandis de 50 %, boutons restylés façon chenille.
- Icône du bouton Accueil : coquille d'escargot en spirale à la place du corps de la maison.
- Cohérence graphique "chenille" étendue : les 4 boutons des coins de la fleur (bornes, escargot, urgences, dépannage) et le bouton Accueil reprennent la forme pétale et le liseré vert des boutons du stepper.
- Pétales de la fleur "en bourgeon" (pleines de vert, pictogramme/texte masqués) au démarrage, et 4 boutons de coin masqués ; le tout se révèle dès que le champ Ville/adresse est rempli (signal local, indépendant du géocodage réseau pour ne jamais bloquer l'utilisateur).
- Correction d'une régression : l'ouverture des pétales dépendait au départ du géocodage réseau, ce qui pouvait les laisser bloquées fermées (plus aucune sélection possible) en cas d'échec/lenteur réseau.
- Photo "forcée" pour chaque lieu en mode données réelles : repli sur Google Street View Static (mêmes coordonnées, même clé API) quand Google Places ne fournit aucune photo pour le lieu.
- **Corrections importantes de fiabilité des données :**
  - `mockContact()` (qui invente un téléphone/site web plausible) n'est plus jamais appliqué aux vrais résultats Google Places — seulement aux lieux fictifs du mode démo. C'était la cause des infos inventées remontées (ex. faux site pour un lieu réel).
  - L'indicateur "mode démo actif / mode données réelles" (bouton 🔑 en haut de l'écran 1) était codé avec l'attribut `hidden` jamais retiré. Retiré un temps pour le rendre visible, puis remasqué à la demande explicite (l'appli tourne volontairement en mode local/démo pour le moment) — les correctifs de fond (mockContact, données Nevers) restent actifs indépendamment de la visibilité de ce bouton.
  - Ajout d'une entrée `nevers` dans les données de démonstration, avec des lieux réels et vérifiés (sources officielles nevers.fr / nevers-tourisme.com) : Cathédrale Saint-Cyr-Sainte-Julitte, Palais Ducal, Musée Frédéric Blandin, Musée archéologique du Nivernais, Sanctuaire Sainte-Bernadette Soubirous, La Maison, restaurants Jean-Michel Couron et Les Dix Vins, Hôtel Molière, Office de Tourisme. Auparavant, toute recherche sur Nevers (ville hors Paris/Bourges) utilisait des lieux 100 % générés (ex. le faux "Olympia de Nevers").

### v2.3 — Réorganisation du projet
- Fichiers rangés dans `assets/images/`, `assets/icons/` et `pages/` (au lieu d'un dossier plat) pour une structure plus professionnelle.
- Correction d'un lien de retour cassé dans la page mentions légales (pointait encore vers l'ancien nom de fichier d'avant le renommage en Margo).

### v2.2 — Nouvelles fonctionnalités guide & fleur
- Export Waze par étape du guide, + convertisseur autonome "Lien Google Maps → Waze" (colle n'importe quel lien Maps, en extrait les coordonnées, génère le lien Waze).
- Suggestions "à proximité" dans le guide : ajoute directement un lieu trouvé mais pas encore intégré, à moins d'1 km d'une étape existante.
- Nouvelles catégories : ⚡ Bornes électriques, 🎤 Salles de concert.
- Fleur repensée : pétales rééquilibrés (espacement régulier quel que soit l'angle), cœur redessiné, dimensionnement 100% proportionnel (adapté à tout écran, y compris mobile) avec raccourcis de navigation fleur ↔ résultats.

### v2.1 — Sécurité, déploiement & PWA
- Audit de sécurité : échappement HTML systématique (protection XSS), liens externes sécurisés (`rel="noopener noreferrer"`), avertissement sur l'exposition de la clé API en déploiement public.
- Application installable comme PWA (écran d'accueil, usage hors-ligne de la coquille) via `manifest.json` et `sw.js`.
- Scripts `lancer-app.bat` (lancement local) et `publier-github.bat` (publication automatisée sur GitHub, avec `.gitignore` généré pour ne jamais publier la clé API).
- Hébergement public via GitHub Pages (`index.html` de redirection).

### v2.0 — Rebranding Margo
- Renommage complet de l'application en **Margo**, nouveau logo, palette de couleurs et typographie assortis.
- Animation GIF d'un escargot suivant le tracé de l'itinéraire, intégrée à la bannière.

### v1.x — Fonctionnalités et ergonomie
- Choix du mode de transport (marche, vélo, voiture, transport en commun) et du profil de marche.
- Suggestion d'itinéraire par un office de tourisme partenaire ou le plus proche (bouton 🐌), carte des bornes de recharge (bouton 🔌).
- Ajout de lieux Google natifs directement depuis les cartes (aperçu itinéraire et guide), réordonnancement manuel des étapes.
- Refonte esthétique complète (fleur interactive, cadres "pétale", cartes Google Maps sur les 4 écrans avec tracé réel et flèches de direction).
- Page Mentions légales / RGPD dédiée.

### v1.0 — Version initiale
- Générateur d'itinéraire touristique en 3 écrans (sélection, options, guide), mode démo et mode données réelles (Google Places/Maps), export HTML/Markdown, QR codes, partage SMS/WhatsApp/email.

## ⚠️ Sécurité — avant de déployer publiquement

`apiki.env` n'est prévu que pour un usage **local**. Si ce site est un jour déployé sur un vrai serveur (au-delà d'un simple test en local), ne publie jamais ce fichier avec le site : la clé API deviendrait librement téléchargeable par n'importe qui. Le script `publier-github.bat` l'exclut automatiquement du dépôt Git.
