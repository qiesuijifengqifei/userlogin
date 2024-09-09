import { defineStore } from 'pinia'
import { reactive } from 'vue'

const useUserStore = defineStore(
  'user',
  () => {
    const userinfo = reactive({
      username: '',
      password: '',
      token: '',
      rememberme: false
    })
    return { 
      userinfo
    }
  },
  {
    persist: true,
  },
)

export { useUserStore }