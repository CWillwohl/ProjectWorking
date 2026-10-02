import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

const port = Number(process.env.VITE_PORT ?? 5173);

export default defineConfig({
    server: {
        // Listen on all interfaces so the dev server is reachable from outside the container
        host: '0.0.0.0',
        port,
        strictPort: true,
        hmr: {
            host: 'localhost',
        },
    },
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
});
