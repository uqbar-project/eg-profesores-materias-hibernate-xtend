package ar.edu.repo

import ar.edu.domain.Materia

class RepoHibernateMaterias extends AbstractRepoHibernate<Materia> {
	
	override get(Long id, boolean deep) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	def void deleteAll() {
		this.executeBatch([ entityManager | entityManager.createQuery("delete from Materia").executeUpdate])
	}
	
}