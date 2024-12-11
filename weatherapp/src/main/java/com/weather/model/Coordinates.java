package com.weather.model;


public class Coordinates {
    @Override
	public String toString() {
		return "location [latitude=" + latitude + ", longitude=" + longitude + "]";
	}
	private String latitude;
    private String longitude;
    
    public void setLatitude(String latitude) {
    	this.latitude = latitude;
    }
    public String getLatittude() {
    	return latitude;
    }
    public void setLongitude(String longitude) {
    	this.longitude = longitude;
    }
    public String getLongitude() {
    	return longitude;
    }
}
