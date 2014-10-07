package ar.edu.repo

import ar.edu.domain.Materia
import ar.edu.domain.Profesor
import org.hibernate.LazyInitializationException
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class TestProfesores {
	
	Profesor spigariol
	Profesor passerini
	Profesor dodino
	Materia paradigmas
	Materia algoritmos
	Materia disenio
	RepoHibernateMaterias repoMaterias
	RepoHibernateProfesores repoProfes
	
	@Before
	def void init() {
		algoritmos = new Materia("Algoritmos y Estructura de Datos", 1)
		paradigmas = new Materia("Paradigmas de Programacion", 2)
		disenio = new Materia("Diseño de Sistemas", 3)
		
		repoMaterias = new RepoHibernateMaterias
		repoMaterias.add(algoritmos)
		repoMaterias.add(paradigmas)
		repoMaterias.add(disenio)
		
		spigariol = new Profesor("Lucas Spigariol")
		spigariol.agregarMateria(algoritmos)
		spigariol.agregarMateria(paradigmas)
		passerini = new Profesor("Nicolás Passerini")
		passerini.agregarMateria(paradigmas)
		passerini.agregarMateria(disenio)
		dodino = new Profesor("Fernando Dodino")
		dodino.agregarMateria(disenio)
		repoProfes = new RepoHibernateProfesores
		repoProfes.add(spigariol)
		repoProfes.add(passerini)
		repoProfes.add(dodino)
	}

	@After
	def void end() {
		repoProfes.delete(spigariol)
		repoProfes.delete(passerini)
		repoProfes.delete(dodino)
		repoMaterias.deleteAll
	}
		
	@Test
	def void testSpigariolDaParadigmas() {
		val profesQueDanParadigmas = repoProfes.getProfesores(paradigmas)
		println("profesQueDanParadigmas: " + profesQueDanParadigmas)
		println("spigariol: " + spigariol)
		Assert.assertTrue(profesQueDanParadigmas.contains(spigariol))
	}

	@Test(expected=LazyInitializationException)
	def void testNoPuedoSaberQueMateriasDaUnProfesorHaciendoGetPorId() {
		val spigariolBase = repoProfes.get(spigariol.id)
		println ("Materias de Spigariol: " + spigariolBase.materias)
	}
	
	@Test
	def void testSiPuedoSaberQueMateriasDaUnProfesorHaciendoGetPorId() {
		val spigariolBase = repoProfes.get(spigariol.id, true)
		println ("Materias de Spigariol: " + spigariolBase.materias)
	}
	
}