package com.analixdata.modelos;

import java.io.Serializable;

public class Usuario implements Serializable {
	private int id,estado;
	private String cedula,nombres,apellidos,cargo,password,email,telefono;
	Empresa empresa;
	Tipo tipo;
	
	public Usuario(){}
	
	
	
	public Usuario(int id, String nombres) {
		super();
		this.id = id;
		this.nombres = nombres;
	}



	public Usuario(String email,String password)
	{
		super();
		this.email=email;
		this.password=password;
	}
	
	public Usuario(int id, String cedula, String nombres, String apellidos,
			String cargo, String email,String telefono,String password,int estado, Empresa empresa, Tipo tipo) {
		super();
		this.id = id;
		this.cedula = cedula;
		this.nombres = nombres;
		this.apellidos = apellidos;
		this.cargo = cargo;
		this.password = password;
		this.email = email;
		this.estado=estado;
		this.telefono=telefono;
		this.empresa= empresa;
		this.tipo=tipo;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getEstado() {
		return estado;
	}

	public void setEstado(int estado) {
		this.estado = estado;
	}

	public String getCedula() {
		return cedula;
	}

	public void setCedula(String cedula) {
		this.cedula = cedula;
	}

	public String getNombres() {
		return nombres;
	}

	public void setNombres(String nombres) {
		this.nombres = nombres;
	}

	public String getApellidos() {
		return apellidos;
	}

	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}

	public String getCargo() {
		return cargo;
	}

	public void setCargo(String cargo) {
		this.cargo = cargo;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public Empresa getEmpresa() {
		return empresa;
	}

	public void setEmpresa(Empresa empresa) {
		this.empresa = empresa;
	}

	public Tipo getTipo() {
		return tipo;
	}

	public void setTipo(Tipo tipo) {
		this.tipo = tipo;
	}
	
	
	
	
	
	
}
