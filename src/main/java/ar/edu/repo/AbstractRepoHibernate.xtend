package ar.edu.repo

import ar.edu.domain.Materia
import ar.edu.domain.Profesor
import org.hibernate.HibernateException
import org.hibernate.Session
import org.hibernate.SessionFactory
import org.hibernate.cfg.AnnotationConfiguration

abstract class AbstractRepoHibernate<T> {
	
	private static final SessionFactory sessionFactory = 
		new AnnotationConfiguration()
			.configure()
			.addAnnotatedClass(Materia)
			.addAnnotatedClass(Profesor)
			.buildSessionFactory()

	def getSessionFactory() {
		sessionFactory
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
		this.executeBatch([ session| (session as Session).save(object)])
	}
		
	def void delete(T object) {
		this.executeBatch([ session| (session as Session).delete(object)])
	}
	
	/**
	 * executeBatch recibe como parametro un closure o expresion lambda:
	 * esa expresion recibe como unico parametro un session y lo aplica a un
	 * bloque que no devuelve nada (void)
	 */
	def void executeBatch((Session)=>void closure) {
		val session = sessionFactory.openSession
		try {
			session.beginTransaction
			closure.apply(session)
			session.transaction.commit
		} catch (HibernateException e) {
			session.transaction.rollback
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}
	
}