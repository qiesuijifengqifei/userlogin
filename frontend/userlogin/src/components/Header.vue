<template>

    <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal" background-color="#545c64"
        text-color="#fff" active-text-color="#ffd04b" :ellipsis="false" @select="handleSelect">
        <el-menu-item index="1">
            <router-link to="/home">
                <span>主页</span>
            </router-link>
        </el-menu-item>

        <el-sub-menu index="2">
            <template #title>{{ current_user.username }}</template>
            <el-menu-item style="min-width: 80px!important;" index="2-1">
                <router-link to="/home/userinfo" key="1">
                    <span>个人中心</span>
                </router-link>
            </el-menu-item>
            <el-menu-item style="min-width: 80px!important;" index="2-2" @click="doLogout">退出登录</el-menu-item>

        </el-sub-menu>
    </el-menu>

</template>
<script lang="ts" setup>
import { ref, reactive, onMounted } from 'vue';
import { tokenaxios } from '../utils/tokenaxios';
import { delToken } from '../stores/token';
import router from '../router/router';

const activeIndex = ref('1')

const current_user = reactive({
    username: '',
    created: '',
})

async function get_current_user() {
    // 获取用户名
    try {
        const response = await tokenaxios("/api/userinfo")
        if (response.status === 200) {
            console.log('获取用户成功')
            current_user.username = response.data.username;
            current_user.created = response.data.created;
            return response.data
        }
    } catch (error: any) {
        console.log(error)
    }
}

const handleSelect = (key: string, keyPath: string[]) => {
    if (key == '1') {
        console.log(key, keyPath)
    }
    else if (key == '2-1') {

    }

}


onMounted(async () => {
    // 页面加载时即调用获取用户名
    get_current_user()
});

const doLogout = () => {
    delToken()
    router.push('/home').then(
        () => {
            location.reload()
        }
    )
}

</script>

<style>
/* 全局使用,不能使用 scoped */
.el-sub-menu {
    margin-left: auto;
    min-width: 80px !important;
}

.el-menu--collapse .el-menu .el-submenu,
.el-menu--popup {
    min-width: 80px !important;
}

.el-menu-demo {
    width: 700px;
    height: 50px;
}
</style>