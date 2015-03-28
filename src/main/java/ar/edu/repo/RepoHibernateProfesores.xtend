package ar.edu.repo

import ar.edu.domain.Materia
import ar.edu.domain.Profesor
import java.util.List
import org.hibernate.HibernateException
import org.hibernate.criterion.Restrictions

class RepoHibernateProfesores extends AbstractRepoHibernate<Profesor> {

	new() {
	}

	def getProfesores(Materia materia) {
		var List<Profesor> result = null
		val session = sessionFactory.openSession
		try {
			result = session
				.createCriteria(typeof(Profesor))
				.createAlias("materias", "materias")
				.add(Restrictions.eq("materias.id", materia.id))
				.list
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}
		result
	}

	override get(Long id, boolean deep) {
		var Profesor profesor = null
		val session = sessionFactory.openSession
		try {
			profesor = session.get(Profesor, id) as Profesor
			if (deep) {
				profesor.materias.size
			}
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}
		profesor
	}

	override delete(Profesor profesor) {
		profesor.clearMaterias()
		super.delete(profesor)
	}
	
}
