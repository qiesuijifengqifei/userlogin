import { createWebHistory, createRouter } from 'vue-router'

const routes = [
  {
    path: '/web1',
    alias: '/',
    component: () => import('../views/Web1.vue'),

    children: [

    ]
  },
  {
    path: '/web1/home',
    component: () => import('../views/UserHome.vue'),
    meta: {
      // 允许匿名访问，即不需要登录 
      anonymousAccess: true
    },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes, // `routes: routes` 的缩写
})

// 全局前置守卫,拦截未登录用户
router.beforeEach(async (to) => {
  if (to.meta.anonymousAccess) {
    return
  }

  else {
    return '/web1/home'
  }
})

export default router