import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'

Vue.use(VueRouter)

const routes: RouteConfig[] = [
  {
    path: '/',
    component: () => import('../views/Main.vue'),
    children: [
      {
        path: '',
        name: 'home',
        component: () => import('../views/Home.vue'),
      },
      {
        path: '/user',
        name: 'user',
        component: () => import('../views/user/User.vue')
      },
      {
        path: '/admin/phone',
        name: 'phone',
        component: () => import('../views/phone/Phone.vue'),
        props: true,
      },
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/login/login.vue'),
    meta: { isPublic: true },
  }
]

const router = new VueRouter({
  routes,
  // mode: 'history'
})
router.beforeEach((to, from, next) => {
  console.log(to);
  if (!to.meta.isPublic && !localStorage.token) {
    return next("/login");
  }
  next();
})

export default router
