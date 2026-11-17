# Clear Praise

A responsive React/JavaScript worship setlist tracker, using Supabase Postgres and Vercel.

## Features

- Build 4- or 5-song setlists with a service date
- Search song titles with autocomplete; new titles are automatically saved to the song library
- Generate random setlists using songs **not used during the 42 days preceding the selected date**; lock songs to retain them on regeneration
- Reorder songs using up/down arrows
- Edit and delete past setlists
- Top 10 most-used and least-used songs, including unused songs in the library
- Search history by song title or date, sort chronologically
- Supabase email/password authentication and shared cloud database

## Setup

1. Create a new Supabase project at https://supabase.com/dashboard.
2. Open **SQL Editor** and run `supabase/schema.sql` once.
3. In Supabase **Authentication → Users**, create a user (email and password). The app intentionally has no public sign-up.
4. Copy `.env.example` to `.env` and fill in **Project URL** and **publishable/anon key** from Supabase project settings. Never use a service-role/secret key in the browser.
5. Run `npm install`, then `npm run dev`.
6. Sign in with the user you created.

## Publish on GitHub

Create a new empty repository on your GitHub account, then from this folder:

```bash
git init
git add .
git commit -m "Initial Clear Praise app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/clear-praise.git
git push -u origin main
```

`.env` is excluded from Git; keep your credentials private.

## Deploy on Vercel

1. Go to https://vercel.com/new and import the GitHub repository.
2. Vercel should detect **Vite**. Build command: `npm run build`; output directory: `dist`.
3. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in the Vercel project's Environment Variables.
4. Deploy. Future pushes to `main` trigger automatic deployments.

## Notes

- Counts are derived from saved setlist/song relationships, so editing or deleting a setlist updates counts automatically.
- The generator uses the selected service date as its reference, not today's date. Songs on the selected date or in the preceding 41 days are excluded; future setlists do not affect the selection.
- New songs can be added by typing them into a setlist and saving it. A dedicated library-management page can be added later if you want to preload never-used songs.
- All authenticated users share one church workspace. For multiple independent churches, add organization membership and organization-scoped RLS policies before inviting outside groups.
- A save involving new songs and relationships uses several database requests rather than one atomic transaction. For production-critical concurrent editing, move saving into a database RPC transaction.
