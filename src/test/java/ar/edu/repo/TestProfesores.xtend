package ar.edu.repo

import ar.edu.domain.Materia
import ar.edu.domain.Profesor
import org.hibernate.LazyInitializationException
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertTrue
import static org.junit.jupiter.api.Assertions.assertThrows

@DisplayName("Dado un profesor que da una materia")
class TestProfesores {

	Profesor spigariol
	Profesor passerini
	Profesor dodino
	Materia paradigmas
	Materia algoritmos
	Materia disenio
	RepoHibernateMaterias repoMaterias
	RepoHibernateProfesores repoProfes

	@BeforeEach
	def void init() {
		algoritmos = new Materia => [
			nombre = "Algoritmos y Estructura de Datos"
			anio = 1
		]
		paradigmas = new Materia => [
			nombre = "Paradigmas de Programacion"
			anio = 2
		]
		disenio = new Materia => [
			nombre = "Diseño de Sistemas"
			anio = 3
		]
		
		repoMaterias = new RepoHibernateMaterias
		repoMaterias.add(algoritmos)
		repoMaterias.add(paradigmas)
		repoMaterias.add(disenio)
		
		spigariol = new Profesor => [
			nombreCompleto = "Lucas Spigariol"
		]
		spigariol.agregarMateria(algoritmos)
		spigariol.agregarMateria(paradigmas)
		passerini = new Profesor => [
			nombreCompleto = "Nicolás Passerini"
		]
		passerini.agregarMateria(paradigmas)
		passerini.agregarMateria(disenio)
		dodino = new Profesor => [
			nombreCompleto = "Fernando Dodino"
		]
		dodino.agregarMateria(disenio)
		repoProfes = new RepoHibernateProfesores
		repoProfes.add(spigariol)
		repoProfes.add(passerini)
		repoProfes.add(dodino)
	}

	@AfterEach
	def void end() {
		repoProfes.delete(spigariol)
		repoProfes.delete(passerini)
		repoProfes.delete(dodino)
		repoMaterias.deleteAll
	}

	@Test
	@DisplayName("si consultamos al repositorio de profesores por materia, aparece ese profesor")
	def void testSpigariolDaParadigmas() {
		val profesQueDanParadigmas = repoProfes.getProfesores(paradigmas)
		assertEquals(2, profesQueDanParadigmas.size)
		assertTrue(profesQueDanParadigmas.contains(spigariol))
	}

	@Test
	@DisplayName("no puedo conocer las materias que da un profesor si la colección es lazy y no la traje")
	def void testNoPuedoSaberQueMateriasDaUnProfesorHaciendoGetPorId() {
		val spigariolBase = repoProfes.get(spigariol.id)
		assertThrows(LazyInitializationException, [ assertEquals(2, spigariolBase.materias.size) ])
	}

	@Test
	@DisplayName("puedo conocer las materias que da un profesor si la colección es lazy y pedí explícitamente traerla")
	def void testSiPuedoSaberQueMateriasDaUnProfesorHaciendoGetPorId() {
		val spigariolBase = repoProfes.get(spigariol.id, true)
		assertEquals(2, spigariolBase.materias.size)
	}

}