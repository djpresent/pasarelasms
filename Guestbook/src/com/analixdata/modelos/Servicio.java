package com.analixdata.modelos;

public class Servicio {

	private int idServicio;
	private String descripcion;
	
	public Servicio()
	{}

	public Servicio(int idServicio, String descripcion) {
		super();
		this.idServicio = idServicio;
		this.descripcion = descripcion;
	}

	private int getIdServicio() {
		return idServicio;
	}

	private void setIdServicio(int idServicio) {
		this.idServicio = idServicio;
	}

	private String getDescripcion() {
		return descripcion;
	}

	private void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	
	
}
