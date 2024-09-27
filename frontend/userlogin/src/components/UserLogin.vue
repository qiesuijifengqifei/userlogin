<script setup lang="ts">
import { ElMessage } from 'element-plus';
import { useUserStore } from '../stores/user.ts';
import { laxios } from '../utils/laxios.ts'
import { ref, reactive } from 'vue'
import { User, Lock } from '@element-plus/icons-vue';

let rturl = window.location.href.indexOf("?") != -1 ? window.location.href.split("?")[1].split("=")[1] : ""

// let current_url = window.location.href.split("//")[1]
// console.log(process.env)                           // 客户端不能获取到此值
// console.log(import.meta.env.VITE_PROXY_URL)        // 客户端能获取到此值

const userStore = useUserStore()
const loginFormData = reactive({
  username: userStore.userinfo.username,
  password: userStore.userinfo.password,
})
const [usernameError, passwordError] = [ref(''), ref('')]

const doLogin = async () => {
  if (loginFormData.username === "") {
    return usernameError.value = "用户名不能为空"
  } else {
    usernameError.value = ""
  }
  if (loginFormData.password === "") {
    return passwordError.value = "密码不能为空"
  } else {
    passwordError.value = ""
  }

  try {
    const response = await laxios.post('/api/login', loginFormData);
    // 登录成功处理逻辑，例如保存token等
    if (response.status == 200) {
      ElMessage({
        message: '登录成功',
        type: 'success',
        plain: true,
      })
      userStore.userinfo.username = loginFormData.username
      userStore.userinfo.access_token = response.data.access_token
      if (userStore.userinfo.rememberme) {
        userStore.userinfo.password = loginFormData.password
      } else {
        userStore.userinfo.password = ""
      }
      if (rturl !== "") {
        rturl = rturl + "?access_token=" + response.data.access_token
        window.location.replace(rturl);
      }
    }
    else {
      return passwordError.value = "密码错误"
    }


  } catch (error: any) {
    // 登录失败处理逻辑
    if (error.status == 401) {
      return passwordError.value = "密码错误"
    }
    ElMessage({
      message: '登录失败',
      type: 'error',
      plain: true,
    })
  }
};

</script>

<template>
  <el-form class="login">
    <el-form-item :error="usernameError">
      <el-input v-model="loginFormData.username" type="text" :prefix-icon="User" placeholder="name" maxlength="10" />
    </el-form-item>

    <el-form-item :error="passwordError">
      <el-input v-model="loginFormData.password" :prefix-icon="Lock" type="password" placeholder="password"
        maxlength="16" show-password @keyup.enter.native="doLogin" />
    </el-form-item>

    <el-form-item>
      <el-checkbox v-model="userStore.userinfo.rememberme" label="记住密码" size="large" />
      <el-button type="primary" @click="doLogin"> 登录 </el-button>
    </el-form-item>

  </el-form>

</template>

<style scoped>
.login {
  width: 200px
}

button {
  right: 0%;
  position: absolute;
  width: 80px
}
</style>
