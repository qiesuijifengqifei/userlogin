import { createWebHistory, createRouter } from 'vue-router'
import UserLogin from '../views/UserLogin.vue'
import UserHome from '../views/UserHome.vue'
import { tokenaxios } from '../utils/tokenaxios'

import UserInfo from '../views/user/UserInfo.vue'



const routes = [
  {
    path: '/',
    alias: '/login',
    component: UserLogin,

    meta: {
      // 允许匿名访问，即不需要登录 
      anonymousAccess: true
    },
    children: [

    ]
  },
  {
    path: '/home',
    component: UserHome,
    meta: {
      // 禁止匿名访问
      anonymousAccess: false,
    },
    children: [
      {
        path: 'userinfo',
        component: UserInfo,
      },
    ]
  },

]

const router = createRouter({
  history: createWebHistory(),
  routes, // `routes: routes` 的缩写
})

// 全局前置守卫,拦截未登录用户
router.beforeEach(async (to) => {
  if (to.meta.anonymousAccess) {
    console.log(to.meta)
    return
  }
  else {
    try {
      const current_user = await tokenaxios("/api/userinfo")
      if (current_user.status === 200) {
        console.log('验证token通过')
        to.meta.current_user = current_user
        return
      } else {
        return '/login'
      }
    } catch (error: any) {
      console.log(error)
      return '/login'
    }
  }
})

export default router