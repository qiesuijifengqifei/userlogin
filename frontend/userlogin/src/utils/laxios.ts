import axios from 'axios';

// 封装 axios
const laxios = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  timeout: 5 * 1000,
  // headers: { "Content-Type": "application/json;charset=UTF-8" }

  // 后端使用 OAuth2PasswordRequestForm ,请求头不可使用 json
  headers: {
    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
  }

});

// 数据请求拦截
laxios.interceptors.request.use(
  // 1. 返回 request 对象
  // 2. 可以设置携带 token 信息
  (request) => {
    const userStore = window.localStorage.getItem('user');
    if (userStore != null) {
      const access_token = JSON.parse(userStore)['userinfo']['access_token'];
      (request.headers.access_token = access_token );
    }
    return request;
  },
  (err) => {
    return Promise.reject(err);
  }
);

// 返回响应数据拦截
laxios.interceptors.response.use(
  (response) => {
    // console.log("request.js打印返回信息" , response);
    // 简化返回数据
    return Promise.resolve(response);
  },
  // 错误执行
  (error) => {
    console.log("错误信息", error);
    if (error.response.status) {
      switch (error.response.status) {
        case 401:
          console.log("用户名或密码不正确！");
          return Promise.reject(error.response);
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

export { laxios };