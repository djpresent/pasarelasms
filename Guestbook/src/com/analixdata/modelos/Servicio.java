package com.analixdata.modelos;

import java.io.Serializable;

public class Servicio implements Serializable{

	private int idServicio;
	private String descripcion;
	
	public Servicio()
	{}

	public Servicio(int idServicio, String descripcion) {
		super();
		this.idServicio = idServicio;
		this.descripcion = descripcion;
	}

	public int getIdServicio() {
		return idServicio;
	}

	public void setIdServicio(int idServicio) {
		this.idServicio = idServicio;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	
	
}
