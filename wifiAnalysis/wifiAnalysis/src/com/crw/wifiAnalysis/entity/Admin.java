package com.crw.wifiAnalysis.entity;

public class Admin {
	private String name;
	private String pwd;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public Admin(String name, String pwd) {
		super();
		this.name = name;
		this.pwd = pwd;
	}
	public Admin() {
		super();
	}
	@Override
	public String toString() {
		return "Admin [name=" + name + ", pwd=" + pwd + "]";
	}
	
	
}
