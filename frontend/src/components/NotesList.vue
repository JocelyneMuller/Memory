<template>
  <div>
    <h2>📒 Liste des notes</h2>
    <ul>
      <li v-for="note in notes" :key="note.id_Note">
        {{ note.Titre }} (Projet ID: {{ note.id_Projet }})
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {
      notes: []
    }
  },
  async mounted() {
    try {
      const response = await fetch('http://localhost:8888/api/notes');
      this.notes = await response.json();
    } catch (error) {
      console.error('Erreur lors du chargement des notes :', error);
    }
  }
}
</script>
