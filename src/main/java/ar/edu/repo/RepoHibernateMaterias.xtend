package ar.edu.repo

import ar.edu.domain.Materia
import org.hibernate.Session

class RepoHibernateMaterias extends AbstractRepoHibernate<Materia> {
	
	override get(Long id, boolean deep) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	def void deleteAll() {
		this.executeBatch([ session| (session as Session).createQuery("delete from Materia").executeUpdate])
	}
	
}