package com.crw.wifiAnalysis.entity;

public class Shop {
	private String id;   //探针Id：店铺
	private String mmac; //探针mac
	private String name; //店铺名
	private String username; //账号
	private String pwd;  //密码
	private String addr; //地址信息
	private String radius; //店铺半径
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMmac() {
		return mmac;
	}
	public void setMmac(String mmac) {
		this.mmac = mmac;
	}
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
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getRadius() {
		return radius;
	}
	public void setRadius(String radius) {
		this.radius = radius;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public Shop(String id, String mmac, String name, String username,
			String pwd, String addr, String radius) {
		super();
		this.id = id;
		this.mmac = mmac;
		this.name = name;
		this.username = username;
		this.pwd = pwd;
		this.addr = addr;
		this.radius = radius;
	}
	public Shop() {
		super();
	}
	
}
