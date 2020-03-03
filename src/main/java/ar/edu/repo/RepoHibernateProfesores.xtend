package ar.edu.repo

import ar.edu.domain.Materia
import ar.edu.domain.Profesor
import javax.persistence.EntityManager
import javax.persistence.criteria.Join
import javax.persistence.criteria.JoinType
import javax.persistence.criteria.Root
import org.hibernate.HibernateException

class RepoHibernateProfesores extends AbstractRepoHibernate<Profesor> {

	
	def getProfesores(Materia materia) {
		val entityManager = createEntityManager
		val query = entityManager.getBasicQuery

		val criteria = entityManager.criteriaBuilder
		val Root<Profesor> from = query.from(Profesor)
		from.alias("materias")
		val Join<Profesor, Materia> materias = from.join("materias", JoinType.INNER)
		query
			.where(criteria.equal(materias.get("id"), materia.id))

		try {
			return entityManager.createQuery(query).resultList
		} finally {
			entityManager.close
		}
	}
	
	override get(Long id, boolean deep) {
		val entityManager = createEntityManager
		val criteria = entityManager.criteriaBuilder

		val query = entityManager.getBasicQuery
		val Root<Profesor> from = query.from(Profesor)
		try {
			query
				.where(criteria.equal(from.get("id"), id))
			
			if (deep) {
				from.fetch("materias", JoinType.INNER)
			}
			return entityManager.createQuery(query).singleResult
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			entityManager.close
		}
	}

	override delete(Profesor profesor) {
		profesor.clearMaterias()
		super.delete(profesor)
	}

	private def getBasicQuery(EntityManager entityManager) {
		return entityManager.criteriaBuilder.createQuery(Profesor)
	}
		
}
