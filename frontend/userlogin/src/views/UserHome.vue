<template>
    <Header></Header>
    <div class="common-layout">
        <el-container style="height: 300px">
            <el-aside width="150px">
                <Aside></Aside>
            </el-aside>

            <el-container>
                <!-- <el-header style="text-align: right; font-size: 12px"></el-header> -->
                <el-main>
                    <span v-if="show()"> welcome ! </span>
                    <router-view :key="$route.fullPath"></router-view>
                </el-main>
            </el-container>
        </el-container>
    </div>



</template>
<script lang="ts" setup>
import Header from '../components/Header.vue';
import Aside from '../components/Aside.vue';

function show() {
    return window.location.pathname == '/home' ? true : false
}
</script>

<style>
.el-aside {
    color: #545c64;
    background: #545c64;
}
</style>