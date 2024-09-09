<script setup lang="ts">
import { ElMessage } from 'element-plus';
import { useUserStore } from '../stores/user.ts';
import { request } from '../utils/request.ts'

let rturl = "";
if ( window.location.href.indexOf("?") != -1 ){
  rturl = window.location.href.split("?")[1].split("=")[1]
  // console.log(rturl)
}

// let current_url = window.location.href.split("//")[1]
// console.log(process.env)                           // 客户端不能获取到此值
// console.log(import.meta.env.VITE_PROXY_URL)        // 客户端能获取到此值

const userStore = useUserStore()
const doLogin = async () => {
  try {    
    const response = await request.post('/api/login', userStore.userinfo);
    // 登录成功处理逻辑，例如保存token等
    if (response.status == 200) {
      ElMessage({
        message: '登录成功',
        type: 'success',
        plain: true,
      })
      userStore.userinfo.token = response.data.token
      if (! userStore.userinfo.rememberme) {
        userStore.userinfo.password = ""
      }
      if (rturl !== "") {
        rturl = rturl + "?token=" + response.data.token
        window.location.replace(rturl);
      }
      
    }
    else {
      ElMessage({
        message: '密码错误',
        type: 'error',
        plain: true,
      })
    }


  } catch (error) {
    // 登录失败处理逻辑
    ElMessage({
      message: '登录失败',
      type: 'error',
      plain: true,
    })
  }
};

</script>

<template>
  <div>
    <br />
    <el-input
      v-model="userStore.userinfo.username"
      type="text"
      placeholder="name"
    />
    <br /><br />
    <el-input
      v-model="userStore.userinfo.password"
      type="password"
      placeholder="password"
      show-password
    />
    <br /><br />
    <el-checkbox v-model="userStore.userinfo.rememberme" label="记住密码" size="large" />
    <span>&nbsp &nbsp &nbsp</span>
    <el-button type="primary" @click="doLogin">Login</el-button>
  </div>
</template>

<style scoped></style>
