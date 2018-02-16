package ar.edu.domain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
class Materia {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id

	@Column
	private String nombre

	@Column
	private int anio
	
	// Lo necesita Hibernate
	new() {}
	
	new(String nombre, int anio) {
		this.nombre = nombre
		this.anio = anio
	}
	
	override toString() {
		nombre + " (" + anio + ")"
	}
		
}