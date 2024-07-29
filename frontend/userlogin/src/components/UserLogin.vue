<script setup lang="ts">
import axios from 'axios';
import { ref , reactive } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { useUserStore } from '../stores/user.ts';

let rturl = "";
if ( window.location.href.indexOf("?") != -1 ){
  rturl = window.location.href.split("?")[1].split("=")[1]
  console.log(rturl)

}

const userStore = useUserStore()
let loginForm = reactive({
  username: '',
  password: ''
});
const rememberme = ref(userStore.userinfo.rememberme)

const doLogin = async () => {

  try {
    // console.log(loginForm);
    const response = await axios.post('/flask/api/login', userStore.userinfo);
    // 登录成功处理逻辑，例如保存token等
    if (response.data.status == '200') {
      ElMessage({
        message: '登录成功',
        type: 'success',
        plain: true,
      })
      console.log(response)
      if (! userStore.userinfo.rememberme) {
        // userStore.userinfo.rememberme = rememberme
        // userStore.userinfo.username = loginForm.username
        userStore.userinfo.password = ""
      }
      rturl = rturl + "?token=" + response.data.data.token
      window.location.replace(rturl);
      
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
