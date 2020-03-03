package ar.edu.repo

import javax.persistence.EntityManager
import javax.persistence.EntityManagerFactory
import javax.persistence.Persistence
import javax.persistence.PersistenceException

abstract class AbstractRepoHibernate<T> {
	
	static final EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("Profesores")

	def createEntityManager() {
		entityManagerFactory.createEntityManager
	}

	def T get(Long id) {
		get(id, false)
	}

	def T get(Long id, boolean deep)
	 
	/* Para el test */
	/* Necesitamos siempre hacer lo mismo:
	 * 1) abrir la sesión
	 * 2) ejecutar un query que actualice
	 * 3) commitear los cambios 
	 * 4) y cerrar la sesión
	 * 5) pero además controlar errores
	 * Entonces definimos un método executeBatch que hace eso
	 * y recibimos un closure que es lo que cambia cada vez
	 * (otra opción podría haber sido definir un template method)
	 */
	def void add(T object) {
		this.executeBatch([ entityManager | entityManager.persist(object) ])
	}
		
	def void delete(T object) {
		this.executeBatch([ entityManager |
			// Hack para evitar el error "Removing a detached instance ar.edu.domain.Profesor#436" 
			val objectToRemove = if (entityManager.contains(object)) object else entityManager.merge(object)
			entityManager.remove(objectToRemove)
		])
	}
	
	/**
	 * executeBatch recibe como parametro un closure o expresion lambda:
	 * esa expresion recibe como unico parametro un session y lo aplica a un
	 * bloque que no devuelve nada (void)
	 */
	def void executeBatch((EntityManager)=>void closure) {
		val entityManager = this.createEntityManager 
		try {
			entityManager => [
				transaction.begin
				closure.apply(entityManager)
				transaction.commit
			]			
		} catch (PersistenceException e) {
			entityManager.transaction.rollback
			throw new RuntimeException(e)
		} finally {
			entityManager.close
		}
	}
	
}