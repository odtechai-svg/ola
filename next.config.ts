import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  // Exclude heavy build-only packages from trace to reduce RAM usage during Docker build
  outputFileTracingExcludes: {
    "*": [
      "node_modules/@swc/**",
      "node_modules/esbuild/**",
      "node_modules/webpack/**",
      "node_modules/next/dist/compiled/webpack/**",
      "node_modules/next/dist/compiled/edge-runtime/**",
      "node_modules/rollup/**",
      "node_modules/terser/**",
    ],
  },
  experimental: {
    typedRoutes: true,
  },
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "lh3.googleusercontent.com",
        pathname: "/aida-public/**",
      },
    ],
  },
};

export default nextConfig;
