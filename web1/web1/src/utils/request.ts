import axios from 'axios';

// 封装 axios
const request = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  timeout: 5 * 1000,
  headers: { "Content-Type": "application/json;charset=UTF-8" }
});


// 数据请求拦截
request.interceptors.request.use(
  // 1. 返回config对象
  // 2. 可以设置携带 token 信息
  (config) => {
    const userStore = window.localStorage.getItem('user');
    if ( userStore != null ) {
      const token = JSON.parse(userStore)['userinfo']['token'];
      (config.headers.token = token);
    }
    return config;
  },
  (err) => {
    return Promise.reject(err);
  }
);

// 返回响应数据拦截
request.interceptors.response.use(
  (response) => {
    // console.log("request.js打印返回信息" , response);
    // 简化返回数据
    return Promise.resolve(response.data);
  },
  // 错误执行
  (error) => {
    console.log("错误信息", error);
    if (error.response.status) {
      switch (error.response.status) {
        case 404:
          console.log("请求路径找不到！");
          break;
        case 500:
          console.log("服务器内部报错！");
          break;
        // 还可以自己添加其他状态码
        default:
          break;
      }
    }
    return Promise.reject(new Error(error.message));
  }
);

// 暴露对象
export { request };