
// 注意 Vite 默认是不加载 .env 文件的，因为这些文件需要在执行完 Vite 配置后才能确定加载哪一个，
// 举个例子，root 和 envDir 选项会影响加载行为。不过当你的确需要时，你可以使用 Vite 导出的 loadEnv 函数来加载指定的 .env 文件。
import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

// console.log(process.env.VITE_PROXY_URL)     // nodejs 运行环境
// console.log(import.meta.env)                // 这里获取不到值
// https://vitejs.dev/config/
export default defineConfig(({ mode, command }) => {
  // 根据当前工作目录中的 `mode` 加载 .env 文件
  // 设置第三个参数为 '' 来加载所有环境变量，而不管是否有 `VITE_` 前缀。
  const env = loadEnv(mode, process.cwd(), 'VITE_')
  // console.log(env.VITE_BASE_URL)
  return {
    // vite 配置
    define: {
      __APP_ENV__: JSON.stringify(env.APP_ENV),
    },
    plugins: [vue()],
    build: {
      outDir: '../../build/frontend/'
    },

    base: env.VITE_BASE_URL,                // 配置部署访问路径

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


  }

})
