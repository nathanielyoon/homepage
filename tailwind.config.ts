import { type Config } from "tailwindcss";

export default {
  content: ["./src/**/*.{ts,tsx,css,html,json}"],
  theme: { extend: {} },
  screens: { sm: "320px", md: "640px", lg: "960px" },
  plugins: [require("@tailwindcss/typography"), require("daisyui")],
  daisyui: { themes: ["black"] },
} satisfies Config;

