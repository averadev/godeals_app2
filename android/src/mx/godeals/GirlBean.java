package mx.godeals;

public class GirlBean {
	
	private String uuid; 
	private String name;
	private double distance;
	private boolean advice;
	
	
	public GirlBean(String uuid, String name, float distance) {
		super();
		this.uuid = uuid;
		this.name = name;
		this.distance = distance;
		this.advice = false;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public double getDistance() {
		return distance;
	}
	public void setDistance(double distance) {
		this.distance = distance;
	}
	public boolean isAdvice() {
		return advice;
	}
	public void setAdvice(boolean advice) {
		this.advice = advice;
	}
	

}
