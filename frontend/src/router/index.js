import { createRouter, createWebHistory } from 'vue-router'

import LoginView      from '@/views/LoginView.vue'
import DashboardView  from '@/views/DashboardView.vue'
import NotesView      from '@/views/NotesView.vue'
import ProjectsView   from '@/views/ProjectsView.vue'
import SkillsView     from '@/views/SkillsView.vue'

export default createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/',           redirect: '/dashboard' },
    { path: '/login',      component: LoginView    },
    { path: '/dashboard',  component: DashboardView },
    { path: '/notes',      component: NotesView    },
    { path: '/projects',   component: ProjectsView },
    { path: '/skills',     component: SkillsView   }
  ]
})
