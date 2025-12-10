import typia from "@ryoppippi/unplugin-typia/vite";
import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import path from "path";
import { defineConfig } from "vite";

const HTTPS_API_ORIGIN = "https://k13e106.p.ssafy.io";
const WS_ORIGIN = "ws://k13e106.p.ssafy.io";

export default defineConfig(({ command }) => ({
  plugins: [
    tailwindcss(),
    react(),
    typia({
      tsconfig: "./tsconfig.app.json",
    }),
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  base: process.env.VITE_BASE_PATH ?? "/",
  server:
    command === "serve"
      ? {
          proxy: {
            "/dev/api": {
              target: HTTPS_API_ORIGIN,
              changeOrigin: true,
              secure: false,
            },
            "/ws": {
              target: WS_ORIGIN,
              changeOrigin: true,
              ws: true,
            },
            "/whep": {
              target: HTTPS_API_ORIGIN,
              changeOrigin: true,
              secure: false,
            },
          },
        }
      : undefined,
}));
