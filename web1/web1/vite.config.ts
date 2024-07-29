import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    port: 8082,   // 配置 vite 端口
    proxy: {
      '/flask': {
        target: 'http://127.0.0.1:8000/',                     // 目标url
        changeOrigin: true,                                   // 允许跨域
        rewrite: (path) => path.replace(/^\/flask/, '')         // 重写路径,替换 /flask
      },
    }
  }
})
