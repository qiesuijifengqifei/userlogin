import { defineStore } from 'pinia'
import { ref, reactive } from 'vue'

export const useUserStore = defineStore(
  'user',
  () => {
    const userinfo = reactive({
      username: '',
      password: '',
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