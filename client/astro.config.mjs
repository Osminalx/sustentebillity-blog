// @ts-check
import { defineConfig } from 'astro/config';

import tailwind from '@astrojs/tailwind';

import node from '@astrojs/node';

// https://astro.build/config
export default defineConfig({

    output: 'hybrid',

    experimental: {
        serverIslands: true,
    },

      integrations: [tailwind()],

    adapter: node({
        mode: 'standalone',
    }),
});

