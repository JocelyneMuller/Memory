<template>
    <h1>Bienvenue sur Memory 🎉</h1>
  <nav style="display:flex; gap:1rem">
    <router-link to="/dashboard">Dashboard</router-link>
    <router-link to="/notes">Notes</router-link>
    <router-link to="/projects">Projets</router-link>
    <router-link to="/skills">Compétences</router-link>
    <router-link to="/login">Login</router-link>
  </nav>

  <hr />

  <!-- Ici s’affiche la page courante -->
  <router-view />
</template>
