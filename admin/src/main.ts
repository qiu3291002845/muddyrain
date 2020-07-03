import Vue from 'vue'
import App from './App.vue'
import './plugins/element'
import router from './router'
import 'bootstrap/dist/css/bootstrap.css'
import 'element-ui/lib/theme-chalk/base.css';

import axios from 'axios'
import store from './store'
Vue.config.productionTip = false



Vue.prototype.$http = axios.create({
  baseURL: "http://127.0.0.1:3000/admin/api"
})
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
