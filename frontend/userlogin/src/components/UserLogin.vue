<script setup lang="ts">
import axios from 'axios';
import { reactive } from 'vue';

const loginForm = reactive({
  username: '',
  password: ''
});

const login = async () => {
  try {
    const response = await axios.post('http://127.0.0.1:5000/api/login', loginForm);
    // 登录成功处理逻辑，例如保存token等
    console.log(response.data);
  } catch (error) {
    // 登录失败处理逻辑
    console.error(error);
  }
};

</script>

<template>
  <div>
    {{ loginForm.username }}
    <input v-model="loginForm.username" type="text" placeholder="Username" />
    <input v-model="loginForm.password" type="password" placeholder="Password" />
    <button @click="login">Login</button>
  </div>
</template>

<style scoped></style>
