# Architecture

## Folder structure
```
app/                    # Next.js App Router routes
  (buyer)/              # public browse, listing detail, RFQ
  (seller)/             # listing submission, tokenised edit
  ops/                  # gated ops console
  api/                  # route handlers only where a server action won't do
components/             # shared UI, shadcn/ui-based
lib/
  supabase/             # client factories (server + browser), generated types
  whatsapp/             # wa.me link builder, message templates — the Cloud API seam
  images/                # client-side compression pipeline
supabase/
  migrations/            # every schema change, timestamped
  seed.sql               # catalogue + regions seed data
docs/                   # this documentation set
.claude/                # skills, agents, rules, hooks
```

## Server vs. client components
Server components are the default. A file becomes a client component only when it needs one of: browser-only state, an event handler, a browser API (camera/file input for photo upload), or a third-party client SDK (PostHog capture). If you're not sure, it's server.

## Data fetching policy
- Server components fetch directly with the server Supabase client — no client-side `useEffect` fetch for data available at render time.
- Mutations go through server actions, not client-side `fetch` to a route handler, except where a route handler is required (e.g. a webhook target).
- The `/ops` console reads and writes with the service role, server-side only. The service role key never reaches a client bundle.
- Public browse/listing reads use the anon key and rely on RLS (@docs/data-model.md) — do not bypass RLS with the service role for a public-facing read.

## Environment variables
| Variable | Public? | Purpose |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | yes | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | yes | anon key, RLS-scoped |
| `SUPABASE_SERVICE_ROLE_KEY` | **no** | `/ops` only, server-side, never in a client bundle |
| `NEXT_PUBLIC_OPS_WHATSAPP_E164` | yes | ops number used to build seller-notify `wa.me` links |
| `OPS_CONSOLE_PASSWORD` | **no** | single shared password gating `/ops` |
| `NEXT_PUBLIC_POSTHOG_KEY` / `NEXT_PUBLIC_POSTHOG_HOST` | yes | analytics |
| `SENTRY_DSN` / `NEXT_PUBLIC_SENTRY_DSN` | split | error tracking, server + client |
| `SUPABASE_PROJECT_REF` | no | used by the Supabase CLI, not the app |
| `SUPABASE_DB_URL` | no | direct Postgres connection string, used by the Supabase CLI for `db push`/`gen types` |
| `SUPABASE_ACCESS_TOKEN` | no | used by the `.mcp.json` Supabase server, not the app |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | no | used by the `.mcp.json` GitHub server, not the app |

Full list with placeholders in `.env.example` at the repo root.

## Error handling
- Server actions return a typed `{ ok: true, data } | { ok: false, error }` shape — no throwing across the server/client boundary for expected failures (validation, RLS denial).
- Unexpected exceptions are caught by Sentry via the Next.js integration; don't hand-roll try/catch around every server component.
- User-facing errors are short and specific ("that phone number looks wrong" not "an error occurred").

## Image pipeline
Seller and listing photos are compressed client-side before upload (target: under ~300KB, longest edge ~1600px) to keep the sub-60-second listing goal plausible on 3G. Compression happens in `lib/images/` before the file reaches Supabase Storage — never upload the original camera file. See the `new-screen` skill for when this applies.
