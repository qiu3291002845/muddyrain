<template>
    <div>
        <el-header height="50" style="height:5vh" class="shadow-lg d-flex pt-1">
            <h4 class="align-middle">
                <img class="mr-2" src="../assets/img/Logo.png" width="36" height="36" />
                <span>浊雨不语 - 后台管理界面</span>
            </h4>
            <div class="user ml-auto">
                <img
                    :src="$store.state.userFrom.imageUrl || '../assets/img/preview.gif'"
                    class="rounded-circle"
                    width="36"
                    height="36"
                    alt
                    srcset
                />
                <el-dropdown trigger="click">
                    <el-button type="text">
                        <span class="ml-2 mr-1">{{ $store.state.userFrom.name || "浊雨不语" }}</span>
                        <i class="el-icon-arrow-down"></i>
                    </el-button>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item>
                            <el-button type="text" @click>个人资料</el-button>
                        </el-dropdown-item>
                        <el-dropdown-item style="padding:0">
                            <el-button type="text" @click="signOut" class="w-100">退出登录</el-button>
                        </el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
            </div>
        </el-header>
        <el-container>
            <el-aside width="200px">
                <el-menu
                    mode="vertical"
                    :default-active="$route.path"
                    class="el-menu-vertical-demo"
                    background-color="#545c64"
                    text-color="#fff"
                    active-text-color="#ffd04b"
                    style="height:95vh"
                    router
                >
                    <el-submenu
                        v-for="(item, index) in menu"
                        :index="`meum-item-${index}`"
                        :key="`meum-item-${index}`"
                    >
                        <template slot="title">{{ item.title }}</template>
                        <el-menu-item
                            v-for="(subItem, subIndex) in item.items"
                            :index="subItem.path"
                            :key="`menu-item-${index}-${subIndex}`"
                        >{{ subItem.title }}</el-menu-item>
                    </el-submenu>
                </el-menu>
            </el-aside>
            <el-container>
                <el-main height>
                    <!-- Main content -->
                    <router-view :key="$route.path"></router-view>
                </el-main>
            </el-container>
        </el-container>
    </div>
</template>
<script lang="ts">
import { Vue, Component } from "vue-property-decorator";
import NoteBook from "./NoteBook.vue";
import Phone from "./Phone.vue";
@Component({})
export default class Main extends Vue {
    private activeName = "first";
    // 侧边栏 数据
    private menu = [
        {
            title: "首页管理",
            items: [
                {
                    title: "首页",
                    path: "/"
                }
            ]
        },
        {
            title: "商品管理",
            items: [
                {
                    title: "笔记本管理",
                    path: "/admin/notebook"
                },
                {
                    title: "手机管理",
                    path: "/admin/phone"
                }
            ]
        },
        {
            title: "运营管理",
            items: [
                {
                    title: "用户管理",
                    path: "/user"
                }
            ]
        },
        {
            title: "博客管理",
            items: [
                {
                    title: "博客分类",
                    path: "/blog/category"
                },
                {
                    title: "新建博客",
                    path: "/blog/edit"
                },
                {
                    title: "博客列表",
                    path: "/blog"
                }
            ]
        }
    ];
    created() {
        if (!this.$store.state.userFrom.name) {
            localStorage.clear();
            location.reload();
            // this.$router.push('/login')
        }
    }
    // 退出登录
    signOut() {
        localStorage.clear();
        location.reload();
    }
}
</script>
<style scoped></style>