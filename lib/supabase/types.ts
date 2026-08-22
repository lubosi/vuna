// Hand-derived from supabase/migrations/20260822143349_initial_schema.sql —
// `pnpm gen:types` needs a Supabase personal access token (SUPABASE_ACCESS_TOKEN)
// that isn't set up yet. Regenerate for real once it is; this file is a
// stand-in, not a substitute.

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Database {
  public: {
    Tables: {
      categories: {
        Row: {
          id: string;
          slug: "fresh_produce" | "meat_poultry" | "dairy" | "flowers";
          name: string;
          sort_order: number;
        };
        Insert: {
          id?: string;
          slug: "fresh_produce" | "meat_poultry" | "dairy" | "flowers";
          name: string;
          sort_order?: number;
        };
        Update: {
          id?: string;
          slug?: "fresh_produce" | "meat_poultry" | "dairy" | "flowers";
          name?: string;
          sort_order?: number;
        };
        Relationships: [];
      };
      products: {
        Row: {
          id: string;
          category_id: string;
          name: string;
          canonical_unit: "kg" | "tonne" | "litre" | "stem";
          aliases: string[];
          grades: string[];
          image_url: string | null;
          is_active: boolean;
        };
        Insert: {
          id?: string;
          category_id: string;
          name: string;
          canonical_unit: "kg" | "tonne" | "litre" | "stem";
          aliases?: string[];
          grades?: string[];
          image_url?: string | null;
          is_active?: boolean;
        };
        Update: {
          id?: string;
          category_id?: string;
          name?: string;
          canonical_unit?: "kg" | "tonne" | "litre" | "stem";
          aliases?: string[];
          grades?: string[];
          image_url?: string | null;
          is_active?: boolean;
        };
        Relationships: [
          {
            foreignKeyName: "products_category_id_fkey";
            columns: ["category_id"];
            referencedRelation: "categories";
            referencedColumns: ["id"];
          },
        ];
      };
      regions: {
        Row: {
          id: string;
          name: string;
          type: "growing" | "market";
          parent_id: string | null;
        };
        Insert: {
          id?: string;
          name: string;
          type: "growing" | "market";
          parent_id?: string | null;
        };
        Update: {
          id?: string;
          name?: string;
          type?: "growing" | "market";
          parent_id?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "regions_parent_id_fkey";
            columns: ["parent_id"];
            referencedRelation: "regions";
            referencedColumns: ["id"];
          },
        ];
      };
      sellers: {
        Row: {
          id: string;
          display_name: string;
          phone_e164: string;
          whatsapp_ok: boolean;
          region_id: string;
          verified_at: string | null;
          verified_by: string | null;
          edit_token: string;
          notes: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          display_name: string;
          phone_e164: string;
          whatsapp_ok?: boolean;
          region_id: string;
          verified_at?: string | null;
          verified_by?: string | null;
          edit_token?: string;
          notes?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          display_name?: string;
          phone_e164?: string;
          whatsapp_ok?: boolean;
          region_id?: string;
          verified_at?: string | null;
          verified_by?: string | null;
          edit_token?: string;
          notes?: string | null;
          created_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: "sellers_region_id_fkey";
            columns: ["region_id"];
            referencedRelation: "regions";
            referencedColumns: ["id"];
          },
        ];
      };
      listings: {
        Row: {
          id: string;
          seller_id: string;
          product_id: string;
          grade: string;
          qty_available: number;
          unit: "kg" | "tonne" | "litre" | "stem";
          price_per_unit: number;
          currency: string;
          moq: number;
          available_from: string | null;
          available_to: string | null;
          region_id: string;
          pickup_note: string | null;
          photos: string[];
          status: "pending_review" | "live" | "paused" | "expired";
          created_at: string;
          reviewed_at: string | null;
          expires_at: string | null;
        };
        Insert: {
          id?: string;
          seller_id: string;
          product_id: string;
          grade: string;
          qty_available: number;
          // Set by the listings_sync_unit trigger from products.canonical_unit —
          // any value passed here is overwritten.
          unit?: "kg" | "tonne" | "litre" | "stem";
          price_per_unit: number;
          currency?: string;
          moq: number;
          available_from?: string | null;
          available_to?: string | null;
          region_id: string;
          pickup_note?: string | null;
          photos?: string[];
          status?: "pending_review" | "live" | "paused" | "expired";
          created_at?: string;
          reviewed_at?: string | null;
          expires_at?: string | null;
        };
        Update: {
          id?: string;
          seller_id?: string;
          product_id?: string;
          grade?: string;
          qty_available?: number;
          unit?: "kg" | "tonne" | "litre" | "stem";
          price_per_unit?: number;
          currency?: string;
          moq?: number;
          available_from?: string | null;
          available_to?: string | null;
          region_id?: string;
          pickup_note?: string | null;
          photos?: string[];
          status?: "pending_review" | "live" | "paused" | "expired";
          created_at?: string;
          reviewed_at?: string | null;
          expires_at?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "listings_seller_id_fkey";
            columns: ["seller_id"];
            referencedRelation: "sellers";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "listings_product_id_fkey";
            columns: ["product_id"];
            referencedRelation: "products";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "listings_region_id_fkey";
            columns: ["region_id"];
            referencedRelation: "regions";
            referencedColumns: ["id"];
          },
        ];
      };
      quote_requests: {
        Row: {
          id: string;
          listing_id: string;
          buyer_name: string;
          buyer_company: string | null;
          buyer_phone_e164: string;
          qty_wanted: number;
          delivery_region_id: string;
          message: string | null;
          status: "new" | "seller_notified" | "responded" | "agreed" | "dead";
          created_at: string;
          first_response_at: string | null;
          closed_at: string | null;
          outcome_note: string | null;
        };
        Insert: {
          id?: string;
          listing_id: string;
          buyer_name: string;
          buyer_company?: string | null;
          buyer_phone_e164: string;
          qty_wanted: number;
          delivery_region_id: string;
          message?: string | null;
          status?: "new" | "seller_notified" | "responded" | "agreed" | "dead";
          created_at?: string;
          first_response_at?: string | null;
          closed_at?: string | null;
          outcome_note?: string | null;
        };
        Update: {
          id?: string;
          listing_id?: string;
          buyer_name?: string;
          buyer_company?: string | null;
          buyer_phone_e164?: string;
          qty_wanted?: number;
          delivery_region_id?: string;
          message?: string | null;
          status?: "new" | "seller_notified" | "responded" | "agreed" | "dead";
          created_at?: string;
          first_response_at?: string | null;
          closed_at?: string | null;
          outcome_note?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "quote_requests_listing_id_fkey";
            columns: ["listing_id"];
            referencedRelation: "listings";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "quote_requests_delivery_region_id_fkey";
            columns: ["delivery_region_id"];
            referencedRelation: "regions";
            referencedColumns: ["id"];
          },
        ];
      };
    };
    Views: Record<string, never>;
    Functions: Record<string, never>;
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
}
