
public class Tipo {
	
	int id;
	String descripcion;
	
	public Tipo(){}
	
	public Tipo(int id, String descripcion) {
		super();
		this.id = id;
		this.descripcion = descripcion;
	}

	private int getId() {
		return id;
	}

	private void setId(int id) {
		this.id = id;
	}

	private String getDescripcion() {
		return descripcion;
	}

	private void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	

}
