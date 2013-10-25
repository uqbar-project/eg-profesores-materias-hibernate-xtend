package ar.edu.home

import ar.edu.domain.Materia
import ar.edu.domain.Profesor
import org.hibernate.LazyInitializationException
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class TestHomeHibernateProfesores {
	
	Profesor spigariol
	Profesor passerini
	Profesor dodino
	Materia paradigmas
	Materia algoritmos
	Materia disenio
	HomeHibernateMaterias homeMaterias
	HomeHibernateProfesores homeProfes
	
	@Before
	def void init() {
		algoritmos = new Materia("Algoritmos y Estructura de Datos", 1)
		paradigmas = new Materia("Paradigmas de Programacion", 2)
		disenio = new Materia("Diseño de Sistemas", 3)
		
		homeMaterias = new HomeHibernateMaterias
		homeMaterias.add(algoritmos)
		homeMaterias.add(paradigmas)
		homeMaterias.add(disenio)
		
		spigariol = new Profesor("Lucas Spigariol")
		spigariol.agregarMateria(algoritmos)
		spigariol.agregarMateria(paradigmas)
		passerini = new Profesor("Nicolás Passerini")
		passerini.agregarMateria(paradigmas)
		passerini.agregarMateria(disenio)
		dodino = new Profesor("Fernando Dodino")
		dodino.agregarMateria(disenio)
		homeProfes = new HomeHibernateProfesores
		homeProfes.add(spigariol)
		homeProfes.add(passerini)
		homeProfes.add(dodino)
	}

	@After
	def void end() {
		homeProfes.delete(spigariol)
		homeProfes.delete(passerini)
		homeProfes.delete(dodino)
		homeMaterias.deleteAll
	}
		
	@Test
	def void testSpigariolDaParadigmas() {
		val profesQueDanParadigmas = homeProfes.getProfesores(paradigmas)
		println("profesQueDanParadigmas: " + profesQueDanParadigmas)
		println("spigariol: " + spigariol)
		Assert.assertTrue(profesQueDanParadigmas.contains(spigariol))
	}

	@Test(expected=LazyInitializationException)
	def void testNoPuedoSaberQueMateriasDaUnProfesorHaciendoGetPorId() {
		val spigariolBase = homeProfes.get(spigariol.id)
		println ("Materias de Spigariol: " + spigariolBase.materias)
	}
	
	@Test
	def void testSiPuedoSaberQueMateriasDaUnProfesorHaciendoGetPorId() {
		val spigariolBase = homeProfes.get(spigariol.id, true)
		println ("Materias de Spigariol: " + spigariolBase.materias)
	}
	
}