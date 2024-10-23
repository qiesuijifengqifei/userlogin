

const setToken = (token: string) => {
  return localStorage.setItem("token", token)
}

const getToken = () => {
  return localStorage.getItem("token")
}

const delToken = () => {
  localStorage.removeItem("token")
}

export { setToken, getToken, delToken }