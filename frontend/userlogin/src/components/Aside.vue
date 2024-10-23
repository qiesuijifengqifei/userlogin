<template>
    <el-row class="tac">

        <el-col>
            <el-menu active-text-color="#ffd04b" background-color="#545c64" class="el-menu-vertical-demo"
                default-active="1" text-color="#fff">
                <el-menu-item index="1">
                    <router-link to="/home/userinfo" key="1">
                        <el-icon><icon-menu /></el-icon>
                        <span>个人中心</span>
                    </router-link>
                </el-menu-item>
                <el-menu-item index="2">
                    <router-link to="/home" key="1">
                        <el-icon><icon-menu /></el-icon>
                        <span>用户管理</span>
                    </router-link>
                </el-menu-item>
            </el-menu>
        </el-col>
    </el-row>
</template>

<script lang="ts" setup>
import { Menu as IconMenu } from '@element-plus/icons-vue'

</script>

<style></style>