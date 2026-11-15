# Détour Foot

Scoreboard, overlay vidéo et app joueur synchronisés en direct. Site statique (aucun build) + Supabase (base, temps réel, comptes) + Vercel (hébergement).

Le logo est dans `public/logo.png` (favicon, en-tête, et logo de compétition de l'overlay).

## Comment Supabase est lié à Vercel
Il n'y a rien à « connecter » dans Vercel : le site tourne dans le navigateur et parle directement à Supabase avec l'URL et la clé `anon public` écrites dans `public/config.js`. Vercel ne fait qu'héberger les fichiers.
1. Supabase > **Project Settings > API** : copie la **Project URL** et la clé **anon public**.
2. Colle-les dans `public/config.js` (`url` et `anonKey`).
3. `git add . && git commit -m "config" && git push` : Vercel redéploie tout seul.
4. Supabase > **Authentication > URL Configuration** : mets l'adresse de ton site Vercel dans **Site URL**.

## 1. Supabase
1. Crée un projet sur supabase.com.
2. **SQL Editor** : colle et lance `supabase/schema.sql`. (Si tu avais déjà lancé l'ancienne version, lance plutôt `supabase/migration-comptes.sql`.)
3. **Authentication > Providers > Email** : désactive **Confirm email**. Sans ça, personne ne peut créer de compte, car les comptes n'ont pas de vraie adresse e-mail.
4. **Project Settings > API** : copie l'URL et la clé `anon public` dans `public/config.js`.

## 2. Comptes : connexion et création de compte
- À l'arrivée sur le site, un écran de chargement s'affiche, puis l'écran **Se connecter / Créer un compte**. Il faut un compte pour entrer. Le bouton avec ton pseudo, en haut à droite, sert à te déconnecter.
- Pseudo : 3 à 20 caractères (lettres, chiffres, `_`). Mot de passe : 6 caractères minimum. Le pseudo s'affiche dans le chat.
- L'adresse `/?view=overlay` (pour OBS) s'ouvre sans compte, pour que la source navigateur fonctionne toute seule.
- Le site fabrique en interne l'adresse `pseudo@gmail.com` (valeur `emailDomain` dans `public/config.js`). Aucun e-mail n'est envoyé. Si Supabase répond que l'adresse est invalide, mets un autre domaine qui existe dans `emailDomain` **et** dans la fonction `make_operator` du SQL, avant de créer des comptes.
- **Compte opérateur** : le pseudo `Noln_mry` devient automatiquement admin dès qu'on le crée. Après le déploiement, ouvre le site, clique « Créer un compte » avec ce pseudo et ton mot de passe : la télécommande s'ouvre. Fais-le en premier, car le premier qui crée ce pseudo devient opérateur.
- **Tous les autres comptes sont des comptes joueur** : ils n'ont ni l'onglet Admin ni l'onglet Overlay, seulement la vue Joueur (chat, paris). Seul `Noln_mry` voit Admin et Overlay.
- Le mot de passe n'est écrit nulle part dans le projet.

## 3. GitHub
```bash
git init && git add . && git commit -m "Détour Foot"
git branch -M main
git remote add origin https://github.com/TON-COMPTE/detour-foot.git
git push -u origin main
```

## 4. Vercel
**Add New > Project**, importe le dépôt. Framework : *Other*, pas de commande de build. `vercel.json` indique le dossier `public`. Chaque `git push` redéploie.

## Utilisation
- `/` : onglets Admin (réservé à l'opérateur), Joueur, Overlay.
- `/?view=overlay` : overlay sur fond transparent, à mettre en source navigateur dans OBS.
- `/?view=player` : ouvre directement la vue joueur.

## Télécommande sur téléphone
Ouvre le site sur ton téléphone, onglet **Admin**, connecte-toi avec ton pseudo : l'écran est conçu pour le tactile (gros boutons, barre de score collée en haut). Astuce : « Ajouter à l'écran d'accueil ».
- **Avant-match** : 5 / 10 / 15 min ou durée libre, puis « Lancer le compte à rebours » : écran « Coup d'envoi dans… » en plein écran avec la musique. À zéro : « GO ! », le chrono du match démarre et la musique s'arrête.
- **Musique** : ambiance synthé intégrée, ou envoi d'une vidéo/musique (50 Mo max, stockée dans Supabase Storage). Le son sort sur l'overlay (OBS) et chez les joueurs, pas sur le téléphone. Les joueurs doivent appuyer une fois sur « Activer le son » (règle des navigateurs).

## Ce qui est synchronisé
Score, chrono, équipes, compétition, style, buts et cartons (animations), phrases, plein écran : l'admin écrit dans `match_state`, tous les écrans reçoivent via Supabase Realtime. Le chat et les paris passent par les tables `chat` et `bets`.

## Enregistrement d'écran (admin uniquement)
Dans l'onglet Admin, « Lancer » ouvre le choix d'une fenêtre, d'un onglet ou de l'écran entier ; « Arrêt » télécharge le fichier `.webm`. Ça marche sur ordinateur (Chrome, Edge, Firefox), pas sur téléphone (les navigateurs mobiles ne le permettent pas). Le fichier reste sur ton appareil.

## Si l'écran de connexion n'apparaît pas
Le site affiche l'écran « Se connecter / Créer un compte » dès que `public/config.js` contient l'URL et la clé Supabase. Sans elles, il affiche un message et un bouton « Voir en mode démo ». Après avoir rempli `config.js`, fais `git push`, attends le redéploiement Vercel, puis recharge la page (Ctrl+Maj+R, ou ferme et rouvre l'onglet sur téléphone).

## Pas encore réel
Musique synthé simple, compos/classement/arbre (données d'exemple), pas de logos de clubs.
