package com.analixdata.negocio;

public class Usuario {
	int id;
	String cedula,nombres,apellidos,cargo,usuario,password,email;
	
	public Usuario(){}
	
	public Usuario(int id, String cedula, String nombres, String apellidos,
			String cargo, String usuario, String password, String email) {
		super();
		this.id = id;
		this.cedula = cedula;
		this.nombres = nombres;
		this.apellidos = apellidos;
		this.cargo = cargo;
		this.usuario = usuario;
		this.password = password;
		this.email = email;
	}
	
	private int getId() {
		return id;
	}
	private void setId(int id) {
		this.id = id;
	}
	private String getCedula() {
		return cedula;
	}
	private void setCedula(String cedula) {
		this.cedula = cedula;
	}
	private String getNombres() {
		return nombres;
	}
	private void setNombres(String nombres) {
		this.nombres = nombres;
	}
	private String getApellidos() {
		return apellidos;
	}
	private void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}
	private String getCargo() {
		return cargo;
	}
	private void setCargo(String cargo) {
		this.cargo = cargo;
	}
	private String getUsuario() {
		return usuario;
	}
	private void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	private String getPassword() {
		return password;
	}
	private void setPassword(String password) {
		this.password = password;
	}
	private String getEmail() {
		return email;
	}
	private void setEmail(String email) {
		this.email = email;
	}

	
	
	
}
