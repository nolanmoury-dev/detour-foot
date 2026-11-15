// Clés publiques Supabase (Project Settings > API). L'anon key est faite pour être publique :
// la sécurité vient des règles RLS de supabase/schema.sql.
window.APP_CONFIG = {
  url: "",      // ex. https://abcdxyz.supabase.co
  anonKey: "",  // clé "anon public"
  // Les comptes se connectent avec un pseudo : le site fabrique en interne l'adresse pseudo@emailDomain.
  // Aucun e-mail n'est jamais envoyé. Ne change plus cette valeur une fois des comptes créés,
  // et garde la même dans supabase/schema.sql (fonction make_operator).
  emailDomain: "gmail.com"
};
