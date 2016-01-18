package com.analixdata.negocio;

public class Transaccion {

	int id;
	String fecha,hora,codRetorno,descError,celular,mensaje;
	
	public Transaccion(){}
	
	public Transaccion(int id, String fecha, String hora, String codRetorno,
			String descError, String celular, String mensaje) {
		super();
		this.id = id;
		this.fecha = fecha;
		this.hora = hora;
		this.codRetorno = codRetorno;
		this.descError = descError;
		this.celular = celular;
		this.mensaje = mensaje;
	}
	
	private int getId() {
		return id;
	}
	private void setId(int id) {
		this.id = id;
	}
	private String getFecha() {
		return fecha;
	}
	private void setFecha(String fecha) {
		this.fecha = fecha;
	}
	private String getHora() {
		return hora;
	}
	private void setHora(String hora) {
		this.hora = hora;
	}
	private String getCodRetorno() {
		return codRetorno;
	}
	private void setCodRetorno(String codRetorno) {
		this.codRetorno = codRetorno;
	}
	private String getDescError() {
		return descError;
	}
	private void setDescError(String descError) {
		this.descError = descError;
	}
	private String getCelular() {
		return celular;
	}
	private void setCelular(String celular) {
		this.celular = celular;
	}
	private String getMensaje() {
		return mensaje;
	}
	private void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
	
	
	
}
