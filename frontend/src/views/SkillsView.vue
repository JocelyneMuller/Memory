<template>
  <div class="skills-container">
    <div class="header">
      <h1>Compétences</h1>
      <div class="header-actions">
        <input
          type="text"
          v-model="searchQuery"
          placeholder="Rechercher..."
          class="search-bar"
        />
        <button @click="showAddModal = true" class="btn-add">
          + Nouvelle Compétence
        </button>
      </div>
    </div>

    <div class="skills-grid">
      <div
        v-for="competence in filteredCompetences"
        :key="competence.id_Competence"
        class="skill-card"
      >
        <h3>{{ competence.Libelle }}</h3>
        <div class="card-actions">
          <button @click="editCompetence(competence)" class="btn-edit">
            Modifier
          </button>
          <button @click="confirmDelete(competence)" class="btn-delete">
            Supprimer
          </button>
        </div>
      </div>
    </div>

    <!-- Modal Ajout/Édition -->
    <div v-if="showAddModal || showEditModal" class="modal-overlay" @click.self="closeModals">
      <div class="modal">
        <h2>{{ showEditModal ? 'Modifier' : 'Ajouter' }} une compétence</h2>
        <form @submit.prevent="saveCompetence">
          <div class="form-group">
            <label for="libelle">Libellé :</label>
            <input
              id="libelle"
              v-model="formData.libelle"
              type="text"
              required
              placeholder="Ex: JavaScript, Vue.js, PHP..."
            />
          </div>
          <div class="form-actions">
            <button type="button" @click="closeModals" class="btn-cancel">
              Annuler
            </button>
            <button type="submit" class="btn-save">
              {{ showEditModal ? 'Modifier' : 'Ajouter' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Modal Confirmation Suppression -->
    <div v-if="showDeleteModal" class="modal-overlay" @click.self="showDeleteModal = false">
      <div class="modal modal-small">
        <h3>Confirmer la suppression</h3>
        <p>Êtes-vous sûr de vouloir supprimer "{{ competenceToDelete?.Libelle }}" ?</p>
        <div class="form-actions">
          <button @click="showDeleteModal = false" class="btn-cancel">
            Annuler
          </button>
          <button @click="deleteCompetence" class="btn-delete">
            Supprimer
          </button>
        </div>
      </div>
    </div>

    <!-- Message de chargement ou d'erreur -->
    <div v-if="loading" class="message">Chargement...</div>
    <div v-if="error" class="message error">{{ error }}</div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import api from '../services/api';

export default {
  name: 'SkillsView',
  setup() {
    const competences = ref([]);
    const searchQuery = ref('');
    const loading = ref(false);
    const error = ref('');

    const showAddModal = ref(false);
    const showEditModal = ref(false);
    const showDeleteModal = ref(false);

    const formData = ref({ libelle: '' });
    const competenceToDelete = ref(null);
    const editingCompetenceId = ref(null);

    const filteredCompetences = computed(() => {
      if (!searchQuery.value) return competences.value;

      const query = searchQuery.value.toLowerCase();
      return competences.value.filter(c =>
        c.Libelle.toLowerCase().includes(query)
      );
    });

    const loadCompetences = async () => {
      loading.value = true;
      error.value = '';
      try {
        const response = await api.getCompetences();
        competences.value = response.data || [];
      } catch (err) {
        error.value = 'Erreur lors du chargement des compétences';
        console.error(err);
      } finally {
        loading.value = false;
      }
    };

    const saveCompetence = async () => {
      try {
        if (showEditModal.value) {
          await api.updateCompetence(editingCompetenceId.value, formData.value);
        } else {
          await api.createCompetence(formData.value);
        }
        await loadCompetences();
        closeModals();
      } catch (err) {
        error.value = 'Erreur lors de la sauvegarde';
        console.error(err);
      }
    };

    const editCompetence = (competence) => {
      formData.value = { libelle: competence.Libelle };
      editingCompetenceId.value = competence.id_Competence;
      showEditModal.value = true;
    };

    const confirmDelete = (competence) => {
      competenceToDelete.value = competence;
      showDeleteModal.value = true;
    };

    const deleteCompetence = async () => {
      try {
        await api.deleteCompetence(competenceToDelete.value.id_Competence);
        await loadCompetences();
        showDeleteModal.value = false;
        competenceToDelete.value = null;
      } catch (err) {
        error.value = 'Erreur lors de la suppression';
        console.error(err);
      }
    };

    const closeModals = () => {
      showAddModal.value = false;
      showEditModal.value = false;
      formData.value = { libelle: '' };
      editingCompetenceId.value = null;
    };

    onMounted(() => {
      loadCompetences();
    });

    return {
      competences,
      searchQuery,
      loading,
      error,
      showAddModal,
      showEditModal,
      showDeleteModal,
      formData,
      competenceToDelete,
      filteredCompetences,
      loadCompetences,
      saveCompetence,
      editCompetence,
      confirmDelete,
      deleteCompetence,
      closeModals
    };
  }
};
</script>

<style scoped>
.skills-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  margin-bottom: 30px;
}

.header h1 {
  color: #333;
  margin-bottom: 20px;
}

.header-actions {
  display: flex;
  gap: 15px;
  align-items: center;
}

.search-bar {
  flex: 1;
  max-width: 400px;
  padding: 10px 15px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
}

.btn-add {
  background-color: #ff6b6b;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: background-color 0.3s;
}

.btn-add:hover {
  background-color: #ff5252;
}

.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
}

.skill-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.skill-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.skill-card h3 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 18px;
}

.card-actions {
  display: flex;
  gap: 10px;
}

.btn-edit, .btn-delete {
  flex: 1;
  padding: 6px 12px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
  transition: background-color 0.3s;
}

.btn-edit {
  background-color: #4CAF50;
  color: white;
}

.btn-edit:hover {
  background-color: #45a049;
}

.btn-delete {
  background-color: #f44336;
  color: white;
}

.btn-delete:hover {
  background-color: #da190b;
}

/* Modals */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background: white;
  border-radius: 12px;
  padding: 30px;
  width: 90%;
  max-width: 500px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.modal-small {
  max-width: 400px;
}

.modal h2, .modal h3 {
  margin-top: 0;
  color: #333;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  color: #666;
  font-size: 14px;
}

.form-group input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
}

.form-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.btn-cancel, .btn-save {
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.btn-cancel {
  background-color: #ccc;
  color: #333;
}

.btn-cancel:hover {
  background-color: #bbb;
}

.btn-save {
  background-color: #4CAF50;
  color: white;
}

.btn-save:hover {
  background-color: #45a049;
}

.message {
  text-align: center;
  padding: 20px;
  font-size: 16px;
  color: #666;
}

.message.error {
  color: #f44336;
}
</style>