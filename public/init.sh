#!/bin/bash

if [ -z "$1" ]; then
  read -p "directory: " directory
else
  directory=$1
fi

mkdir $directory
cd $directory

cat > package.json << EOF
{
  "name": "$directory",
  "scripts": {
    "dev": "solid-start dev",
    "build": "solid-start build",
    "start": "solid-start start"
  },
  "type": "module",
  "devDependencies": {
    "@cloudflare/workers-types": "latest",
    "@tailwindcss/typography": "latest",
    "@types/node": "latest",
    "autoprefixer": "latest",
    "daisyui": "latest",
    "postcss": "latest",
    "prettier": "latest",
    "prettier-plugin-tailwindcss": "latest",
    "solid-start-cloudflare-pages": "latest",
    "solid-start-node": "latest",
    "tailwindcss": "latest",
    "ts-node": "latest",
    "typescript": "latest",
    "vite": "latest"
  },
  "dependencies": {
    "@solidjs/meta": "latest",
    "@solidjs/router": "latest",
    "firebase": "latest",
    "solid-js": "latest",
    "solid-start": "latest",
    "undici": "latest"
  },
  "engines": {
    "node": ">=16"
  }
}
EOF
cat > tailwind.config.ts << EOF
import { type Config } from "tailwindcss";

export default {
  content: ["./src/**/*.{ts,tsx,css,html,json}"],
  theme: { extend: {} },
  screens: { sm: "320px", md: "640px", lg: "960px" },
  plugins: [require("@tailwindcss/typography"), require("daisyui")],
  daisyui: { themes: ["black"] },
} satisfies Config;
EOF
cat > postcss.config.cjs << EOF
module.exports = {
  plugins: { tailwindcss: {}, autoprefixer: {} },
};
EOF
cat > .prettierrc << EOF
{
  "plugins": ["prettier-plugin-tailwindcss"]
}
EOF
cat > tsconfig.json << EOF
{
  "include": ["src/**/*"],
  "exclude": ["functions/**/*"],
  "compilerOptions": {
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "node",
    "jsxImportSource": "solid-js",
    "jsx": "preserve",
    "strict": true,
    "types": ["solid-start/env", "@cloudflare/workers-types"],
    "baseUrl": "./",
    "paths": {
      "~/*": ["./src/*"]
    }
  }
}
EOF
cat > vite.config.ts << EOF
import { defineConfig } from "vite";
import solid from "solid-start/vite";
import cloudflare from "solid-start-cloudflare-pages";

export default defineConfig({
  plugins: [
    solid({
      adapter: cloudflare({
        envPath: true,
      }),
    }),
  ],
});
EOF

mkdir public
cat > public/favicon.svg << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" stroke-width="2" stroke="#000" fill="#ffe135" stroke-linecap="round">
  <path d="M1,8 a7,7,0 1,0 14,0 a7,7 0,1,0 -14,0" />
  <path d="M6,10 v0.2 m4,-0.2 v0.2" />
  <path d="M5,6 a5,7 0,0,1 6,0" />
</svg>
EOF

mkdir src
cd src
cat > root.css << EOF
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
cat > root.tsx << EOF
// @refresh reload
import { Suspense } from "solid-js";
import {
  Body,
  ErrorBoundary,
  FileRoutes,
  Head,
  Html,
  Link,
  Meta,
  Routes,
  Scripts,
} from "solid-start";

import "./root.css";

export default () => {
  return (
    <Html lang="en">
      <Head>
        <Meta charset="utf-8" />
        <Meta name="viewport" content="width=device-width, initial-scale=1" />
        <Link rel="icon" href="/favicon.svg" />
      </Head>
      <Body>
        <Suspense>
          <ErrorBoundary>
            <Routes>
              <FileRoutes />
            </Routes>
          </ErrorBoundary>
        </Suspense>
        <Scripts />
      </Body>
    </Html>
  );
};
EOF
cat > entry-client.tsx << EOF
import { mount, StartClient } from "solid-start/entry-client";

mount(() => <StartClient />, document);
EOF
cat > entry-server.tsx << EOF
import {
  StartServer,
  createHandler,
  renderAsync,
} from "solid-start/entry-server";

export default createHandler(
  renderAsync((event) => <StartServer event={event} />),
);
EOF

mkdir lib
cat > lib/Counter.tsx << EOF
import { createSignal } from "solid-js";

export default () => {
  const [count, setCount] = createSignal(0);
  return (
    <div class="flex h-screen w-full items-center justify-center">
      <button
        onclick={() => setCount((current) => current + 1)}
        class="btn btn-primary btn-lg"
      >
        {count()}
      </button>
    </div>
  );
};
EOF

mkdir routes
cat > routes/index.tsx << EOF
import Counter from "~/lib/Counter";

export default () => <Counter />;
EOF

cd ..
pnpm install

git init
cat > .gitignore << EOF
.directory
*debug.log
.vscode

dist
.solid
.output
/node_modules
EOF
git add -A
git commit -m "initial"
