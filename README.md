# Selara Tumbler

Vanilla HTML, CSS, and JavaScript storefront and admin panel. Supabase stores catalog and admin data; product photos use the public `product-images` Storage bucket.

## Setup

1. Create/open the Supabase project `selara-tumbler`.
2. Run `supabase/schema.sql` in the Supabase SQL Editor, then run `supabase/seed.sql`.
3. Create the admin account in Supabase Authentication. Add its auth user ID to `public.admin_users` from the SQL Editor:
   `insert into public.admin_users (user_id) values ('AUTH_USER_UUID');`
4. Copy `.env.example` to `.env` for local configuration. Keep `.env` private and never commit it.
5. Install Node.js dependencies with `npm install`, then run `npm run build` before serving locally. The build writes ignored `runtime-config.js` from `.env`.
6. Set `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `WA_NUMBER` in Netlify site environment variables before deploy.

The public storefront must query `products_public`; it does not expose `cost_price`. Admin table access and product image upload are restricted by RLS to user IDs in `admin_users`. The WhatsApp number is configuration only and must be used only to construct the checkout link.

## Deploy

Connect the GitHub repository `selara-tumbler` to Netlify. Use the repository root as the publish directory; the build command generates `runtime-config.js` from the site environment variables. `netlify.toml` contains the build and `/admin/*` redirect settings. Netlify assigns a free `*.netlify.app` domain.

## Admin

The sign-in form uses Supabase Auth email/password (the existing username-labeled field accepts the admin account email). No service-role key belongs in browser code or Netlify client-facing configuration.
