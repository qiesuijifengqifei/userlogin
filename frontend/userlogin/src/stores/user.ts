import { defineStore } from 'pinia'
import { reactive } from 'vue'

const useUserStore = defineStore(
  'user',
  () => {
    const userinfo = reactive({
      username: '',
      password: '',
      access_token: '',
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