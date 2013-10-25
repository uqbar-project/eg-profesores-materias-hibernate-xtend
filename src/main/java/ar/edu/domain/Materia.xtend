package ar.edu.domain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id

@Entity
class Materia {

	@Id
	@GeneratedValue
	@Property private Long id

	@Column
	@Property private String nombre

	@Column
	@Property private int anio
	
	// Lo necesita Hibernate
	new() {
		
	}
	
	new(String nombre, int anio) {
		this.nombre = nombre
		this.anio = anio
	}
	
	override toString() {
		nombre + " (" + anio + ")"
	}
		
}