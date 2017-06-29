package com.cxw.wifiAnalysis.dao;


import com.crw.wifiAnalysis.entity.Shop;

public interface IShopDao {
	/**
	 * 添加店铺信息的方法
	 * @param sh
	 * @return
	 */
	public int addShop(Shop sh);
	/**
	 * 店铺管理员登录
	 * @param name
	 * @param pwd
	 * @return
	 */
	public Shop shopLogin(String name, String pwd);
}
