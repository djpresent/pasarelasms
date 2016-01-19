package com.analixdata.modelos;

public class Empresa {

private int idEmpresa,estado;
private String nombre, direccion, telefono, contacto;


public Empresa()
{}


public Empresa(int idEmpresa, int estado, String nombre, String direccion,String telefono, String contacto) 
{
	super();
	this.idEmpresa = idEmpresa;
	this.estado = estado;
	this.nombre = nombre;
	this.direccion = direccion;
	this.telefono = telefono;
	this.contacto = contacto;
}


private int getIdEmpresa() {
	return idEmpresa;
}


private void setIdEmpresa(int idEmpresa) {
	this.idEmpresa = idEmpresa;
}


private int getEstado() {
	return estado;
}


private void setEstado(int estado) {
	this.estado = estado;
}


private String getNombre() {
	return nombre;
}


private void setNombre(String nombre) {
	this.nombre = nombre;
}


private String getDireccion() {
	return direccion;
}


private void setDireccion(String direccion) {
	this.direccion = direccion;
}


private String getTelefono() {
	return telefono;
}


private void setTelefono(String telefono) {
	this.telefono = telefono;
}


private String getContacto() {
	return contacto;
}


private void setContacto(String contacto) {
	this.contacto = contacto;
}



	
}
