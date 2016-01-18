package com.analixdata.negocio;

public class Servicio {

	int idServicio;
	String descripcion;
	
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
