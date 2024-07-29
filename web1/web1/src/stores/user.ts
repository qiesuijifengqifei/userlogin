import { defineStore } from 'pinia'
import { ref, reactive } from 'vue'
import axios from 'axios'

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