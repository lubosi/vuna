import { createBrowserClient } from "@supabase/ssr";

/**
 * Anon-key client for the rare case a client component needs to talk to
 * Supabase directly (e.g. a realtime subscription). Most reads should go
 * through a server component instead — see docs/architecture.md.
 */
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  );
}
