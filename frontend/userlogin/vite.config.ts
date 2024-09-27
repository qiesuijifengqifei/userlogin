import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// console.log(process.env.VITE_PROXY_URL)     // nodejs 运行环境
// console.log(import.meta.env)                // 这里获取不到值
// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  build: {
    outDir: '../../build/frontend/'
  },
  base: '/static',                // 配置部署访问路径

  // axios 是不允许跨域的,可通过代理形式支持,这种修改方式是伪跨域,前提是后端不作限制
  // 这里做法还是通过后端 api 实现支持跨域
  server: {
    host: '0.0.0.0',            // 配置使用 ip 能访问
    port: 8081,                 // 配置 vite 端口
    strictPort: true,
    // proxy: {
    //   '/flask': {
    //     target: '/api/login',                     // 目标url
    //     changeOrigin: true,                                     // 允许跨域
    //     rewrite: (path) => path.replace(/\/flask/, '')         // 重写路径,替换 /flask
    //   }
    // }
  }
})
