<template>

    <el-tabs v-model="activeName" class="demo-tabs" @tab-click="handleClick">
        <el-tab-pane label="User" name="user">
            <el-descriptions :column="1" title="个人信息" border>

                <el-descriptions-item label="Username">{{ current_user.username }}</el-descriptions-item>
                <el-descriptions-item label="Created">{{ current_user.created }}</el-descriptions-item>
                <!-- <el-descriptions-item label="Place">Suzhou</el-descriptions-item> -->


            </el-descriptions>

        </el-tab-pane>
        <el-tab-pane label="Config" name="config">Config</el-tab-pane>

    </el-tabs>
</template>
<script lang="ts" setup>
import { ref, reactive, onMounted } from 'vue';
import type { TabsPaneContext } from 'element-plus';
import { tokenaxios } from '../../utils/tokenaxios';

const activeName = ref('user')


const current_user = reactive({
    username: '',
    created: '',
})

async function get_current_user() {
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

const handleClick = async (tab: TabsPaneContext, event: Event) => {
    console.log(event)
    if (tab.props.name == 'user') {
        get_current_user()
    }
    // console.log(tab.props.name)
}


onMounted(async () => {

    get_current_user()
});

</script>

<style>
.el-tabs {
    margin-top: 0%;
}
.demo-tabs {
    width: 400px;
    height: 150px;
    padding: 32px;
}

.demo-tabs>.el-tabs__content {
    padding: 32px;
    color: #6b778c;
    font-size: 32px;
    font-weight: 600;
}

</style>