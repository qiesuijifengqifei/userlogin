<template>
  <el-container class="layout-container-demo" style="height: 500px">
    <el-aside width="200px">
      <span>web1</span>
    </el-aside>

    <el-container>
      <el-header style="text-align: right; font-size: 12px">
        <div class="toolbar">
          <template v-if="userStore.userinfo.islogin">
            <span> {{ userStore.userinfo.username }} </span>
            <span> &nbsp / &nbsp </span>
            <el-link @click="doLogout"> 注销 </el-link>
          </template>

          <template v-else>
            <el-link :href=rturl target="_blank">登录</el-link>
          </template>
          
          <!-- Chrome 浏览器，_blank 方式新开窗口，sessionStorage 存储的数据会丢失。 -->
        </div>
      </el-header>

      <el-main>

      </el-main>
    </el-container>
  </el-container>
</template>

<script lang="ts" setup>
import { request } from '../utils/request.ts'
import { useUserStore } from '../stores/user';

const userStore = useUserStore()
if (window.location.href.indexOf("?") != -1) {
  let token = window.location.href.split("?")[1].split("=")[1]
  console.log("save token", token)
  userStore.userinfo.token = token
}

const clear_userStore = async () => {
  userStore.userinfo.username = ""
  userStore.userinfo.token = ""
  userStore.userinfo.islogin = false
}

const doLogout = async () => {
  const response = await request.post('/api/logout', {}, {
    headers: {
      'token': userStore.userinfo.token
    }
  });
  if (response.status == 200) {
    console.log(response)
    clear_userStore()
    location.reload()
  } 
  else{
    console.log("logout failed")
  }
}

const checkToken = async () => {
  if (userStore.userinfo.token == "") {
    console.log("未获取到 token ,请先登录")
  } 
  else {
    const response = await request.post('/api/userinfo', {}, {
      headers: {
        'token': userStore.userinfo.token
      }
    });
    console.log(response)
    if (response.status == 200) {
      if (response.data?.isvalid !== undefined && response.data.isvalid) {
        userStore.userinfo.islogin = true
        userStore.userinfo.username = response.data.username
      }
      else{
        clear_userStore()
      }

    } 
    else {
      console.log("fail")
    }
  }

}
checkToken()

history.pushState("", "", "home")

const rturl = "http://127.0.0.1:8081?rturl=" + window.location.href

</script>

<style scoped>
.layout-container-demo .el-header {
  position: relative;
  background-color: var(--el-color-primary-light-7);
  color: var(--el-text-color-primary);
}

.layout-container-demo .el-aside {
  color: var(--el-text-color-primary);
  background: var(--el-color-primary-light-8);
}

.layout-container-demo .el-menu {
  border-right: none;
}

.layout-container-demo .el-main {
  padding: 0;
}

.layout-container-demo .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 20px;
}
</style>