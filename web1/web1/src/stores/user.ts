import { defineStore } from 'pinia'
import { reactive } from 'vue'

export const useUserStore = defineStore('user', () => {
  const userinfo = reactive({
    'token': "",
    'username': "",
    'islogin': false

  })

  return {
    userinfo,
    // setUserInfo
    
  }
},
  {
    persist: true,
  },
)