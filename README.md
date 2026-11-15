# Détour Foot

Scoreboard, overlay vidéo et app joueur synchronisés en direct. Site statique (aucun build) + Supabase (base, temps réel, auth) + Vercel (hébergement).

Le logo est dans `public/logo.png` (favicon, en-tête, et logo de compétition de l'overlay).

## 1. Supabase
1. Crée un projet sur supabase.com.
2. **SQL Editor** : colle et lance `supabase/schema.sql`.
3. **Authentication > Users > Add user** : crée ton compte admin (e-mail + mot de passe).
4. Dans le SQL Editor, donne-lui les droits admin :
   ```sql
   insert into public.admins (user_id) select id from auth.users where email = 'ton@email.com';
   ```
5. **Project Settings > API** : copie l'URL et la clé `anon public` dans `public/config.js`.

## 2. GitHub
```bash
git init && git add . && git commit -m "Détour Foot"
git branch -M main
git remote add origin https://github.com/TON-COMPTE/detour-foot.git
git push -u origin main
```

## 3. Vercel
**Add New > Project**, importe le dépôt. Framework : *Other*, pas de commande de build. `vercel.json` indique le dossier `public`. Chaque `git push` redéploie.

## Utilisation
- `/` : onglets Admin (connexion requise), Joueur, Overlay.
- `/?view=overlay` : overlay sur fond transparent, à mettre en source navigateur dans OBS.
- `/?view=player` : ouvre directement la vue joueur.

## Télécommande sur téléphone
Ouvre le site sur ton téléphone, onglet **Admin**, connecte-toi : l'écran est conçu pour le tactile (gros boutons, barre de score collée en haut). Astuce : « Ajouter à l'écran d'accueil ».
- **Avant-match** : 5 / 10 / 15 min ou durée libre, puis « Lancer le compte à rebours » : écran « Coup d'envoi dans… » en plein écran avec la musique. À zéro : « GO ! », le chrono du match démarre et la musique s'arrête.
- **Musique** : ambiance synthé intégrée, ou envoi d'une vidéo/musique (50 Mo max, stockée dans Supabase Storage). Le son sort sur l'overlay (OBS) et chez les joueurs, pas sur le téléphone. Les joueurs doivent appuyer une fois sur « Activer le son » (règle des navigateurs).

## Ce qui est synchronisé
Score, chrono, équipes, compétition, style, buts et cartons (animations), phrases, plein écran : l'admin écrit dans `match_state`, tous les écrans reçoivent via Supabase Realtime. Le chat et les paris passent par les tables `chat` et `bets`.

## Pas encore réel
Musique et enregistrement d'écran (maquettes), compos/classement/arbre (données d'exemple), pas de logos de clubs.
