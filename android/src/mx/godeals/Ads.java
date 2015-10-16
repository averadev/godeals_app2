package mx.godeals;

public class Ads {
	
	private int id;
	private String message;
	private String uuid;
	private double latitude;
	private double longitude;
	private double distanceMin;
	private double distanceMax;
    private int partnerId;
    private int type;
	private String image;
	private int status;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public double getDistanceMin() {
		return distanceMin;
	}
	public void setDistanceMin(double distanceMin) {
		this.distanceMin = distanceMin;
	}
	public double getDistanceMax() {
		return distanceMax;
	}
	public void setDistanceMax(double distanceMax) {
		this.distanceMax = distanceMax;
	}
    public int getPartnerId() {
		return partnerId;
	}
	public void setPartnerId(int partnerId) {
		this.partnerId = partnerId;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
    public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
}
