<template>
  <div>
    <el-tabs v-model="editableTabsValue" type="card" editable @edit="handleTabsEdit">
      <el-tab-pane :key="item.name" v-for="(item, index) in editableTabs" :label="item.title" :name="item.name">
        <router-view :name="item.content" :key="$route.path"></router-view>
      </el-tab-pane>
    </el-tabs>
    <!-- <h1>笔记本管理</h1> -->
  </div>
</template>

<script lang="ts">
  import {
    Vue,
    Component
  } from "vue-property-decorator";
  @Component({
    components: {}
  })
  export default class NoteBook extends Vue {
    editableTabsValue = "1";
    editableTabs = [{
        title: "新建笔记本",
        name: "1",
        content: "notebookeCreate"
      },
      {
        title: "笔记本列表",
        name: "2",
        content: "notebookeList"
      }
    ];
    tabIndex = 2;
    handleTabsEdit(targetName: any, action: any) {
      if (action === "add") {
        let newTabName = ++this.tabIndex + "";
        this.editableTabs.push({
          title: "New Tab",
          name: newTabName,
          content: "New Tab content"
        });
        this.editableTabsValue = newTabName;
      }
      if (action === "remove") {
        let tabs = this.editableTabs;
        let activeName = this.editableTabsValue;
        if (activeName === targetName) {
          tabs.forEach((tab, index) => {
            if (tab.name === targetName) {
              let nextTab = tabs[index + 1] || tabs[index - 1];
              if (nextTab) {
                activeName = nextTab.name;
              }
            }
          });
        }
        this.editableTabsValue = activeName;
        this.editableTabs = tabs.filter(tab => tab.name !== targetName);
      }
    }
  }
</script>

<style lang="scss">
</style>