package com.analixdata.negocio;

public class ServicioEmpresa {

	int idServicio, idEmpresa,limite,activo;
	float costoTransaccion;
	
	
	
	public ServicioEmpresa() {
	}



	public ServicioEmpresa(int idServicio, int idEmpresa, int limite,
			int activo, float costoTransaccion) {
		super();
		this.idServicio = idServicio;
		this.idEmpresa = idEmpresa;
		this.limite = limite;
		this.activo = activo;
		this.costoTransaccion = costoTransaccion;
	}



	private int getIdServicio() {
		return idServicio;
	}



	private void setIdServicio(int idServicio) {
		this.idServicio = idServicio;
	}



	private int getIdEmpresa() {
		return idEmpresa;
	}



	private void setIdEmpresa(int idEmpresa) {
		this.idEmpresa = idEmpresa;
	}



	private int getLimite() {
		return limite;
	}



	private void setLimite(int limite) {
		this.limite = limite;
	}



	private int getActivo() {
		return activo;
	}



	private void setActivo(int activo) {
		this.activo = activo;
	}



	private float getCostoTransaccion() {
		return costoTransaccion;
	}



	private void setCostoTransaccion(float costoTransaccion) {
		this.costoTransaccion = costoTransaccion;
	}
	
	
	
	
}
