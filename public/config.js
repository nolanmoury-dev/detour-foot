// Clés publiques Supabase (Project Settings > API). L'anon key est faite pour être publique :
// la sécurité vient des règles RLS de supabase/schema.sql.
window.APP_CONFIG = {
  url: "https://woqwutxjgekjhyjgewqp.supabase.co",
  anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndvcXd1dHhqZ2Vramh5amdld3FwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTQ3NjAwMzQsImV4cCI6MjExMDMzNjAzNH0.FdEk_1v5D-FqHWY-pfQ_zf9gNjq29vQ_-DnO4r5qpF4",
  // Les comptes se connectent avec un pseudo : le site fabrique en interne l'adresse pseudo@emailDomain.
  // Aucun e-mail n'est jamais envoyé. Ne change plus cette valeur une fois des comptes créés,
  // et garde la même dans supabase/schema.sql (fonction make_operator).
  emailDomain: "gmail.com"
};
