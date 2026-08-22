import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Vuna",
  description:
    "A B2B marketplace connecting African farmers and producers with buyers.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className="h-full antialiased">
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
