const API_URL = 'http://localhost/Memory_VF/Memory/backend/public';

class ApiService {
    async request(url, options = {}) {
        try {
            const response = await fetch(`${API_URL}${url}`, {
                ...options,
                headers: {
                    'Content-Type': 'application/json',
                    ...options.headers
                }
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.error || 'Une erreur est survenue');
            }

            return data;
        } catch (error) {
            console.error('API Error:', error);
            throw error;
        }
    }

    // CRUD Compétences
    async getCompetences() {
        return this.request('/api/competences');
    }

    async getCompetence(id) {
        return this.request(`/api/competences/${id}`);
    }

    async createCompetence(data) {
        return this.request('/api/competences', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    }

    async updateCompetence(id, data) {
        return this.request(`/api/competences/${id}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    }

    async deleteCompetence(id) {
        return this.request(`/api/competences/${id}`, {
            method: 'DELETE'
        });
    }

    // CRUD Notes
    async getNotes() {
        return this.request('/api/notes');
    }

    // CRUD Projets (à implémenter)
    async getProjets() {
        return this.request('/api/projets');
    }

    async getProjet(id) {
        return this.request(`/api/projets/${id}`);
    }

    async createProjet(data) {
        return this.request('/api/projets', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    }

    async updateProjet(id, data) {
        return this.request(`/api/projets/${id}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    }

    async deleteProjet(id) {
        return this.request(`/api/projets/${id}`, {
            method: 'DELETE'
        });
    }
}

export default new ApiService();