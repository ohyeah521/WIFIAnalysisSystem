package com.crw.wifiAnalysis.dao.impl;

import java.util.ArrayList;
import java.util.List;


import com.crw.wifiAnalysis.entity.Shop;
import com.crw.wifiAnalysis.utils.MongoDBUtil;
import com.cxw.wifiAnalysis.dao.IShopDao;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class ShopDaoImpl implements IShopDao {

	@Override
	public int addShop(Shop sh) {
		try {
			DB db = MongoDBUtil.getDb();
			DBCollection collection = db.getCollection("shop");
			System.out.println("集合 shop 选择成功");
			// 插入文档
			List<DBObject> dbList = new ArrayList<DBObject>();  
	        BasicDBObject doc = new BasicDBObject();  
	        doc.put("ID", sh.getId());  
	        doc.put("mmac", sh.getMmac());  
	        doc.put("name", sh.getName());  
	        doc.put("username", sh.getUsername());
	        doc.put("password", sh.getPwd());
	        doc.put("rate", "");
	        doc.put("wssid", "");
	        doc.put("wmac", "");
	        doc.put("lat", "");
	        doc.put("lon", "");
	        doc.put("addr", sh.getAddr());
	        doc.put("radius", sh.getRadius());
	        doc.put("customerlist", "");
	        dbList.add(doc);  
	        
	        /**
	         * 用户去重判断
	         */
			//临时条件对象：
			BasicDBObject cond = null;
			cond = new BasicDBObject();
			cond.put("username", sh.getUsername());
			
			DBCursor ret = collection.find(cond);
			if(ret.hasNext()){
				System.out.println("文档插入失败，用户已存在！");
				return 0;
			}else {
				collection.insert(dbList);
				System.out.println("文档插入成功");
				return 1;
			}
			
		} catch (Exception e) {
			System.out.println("数据库连接失败，注册失败");
			return 2;
		}
	}

	@Override
	public Shop shopLogin(String username,String pwd) {
		Shop shop = new Shop();
		try {
			DB db = MongoDBUtil.getDb();
			DBCollection collection =  db.getCollection("shop");
			
			//匹配
			//临时条件对象：
			BasicDBObject cond = null;
			cond = new BasicDBObject();
			cond.put("username", username);
			
			DBCursor ret = collection.find(cond);
			
			while(ret.hasNext()) {
				DBObject dbObject = ret.next();
				String pwdString = dbObject.get("password").toString();
				if(pwdString.equals(pwd)){
					shop.setAddr(dbObject.get("addr").toString());
					shop.setId(dbObject.get("ID").toString());
					shop.setMmac(dbObject.get("mmac").toString());
					shop.setName(dbObject.get("name").toString());
					shop.setUsername(dbObject.get("username").toString());
					shop.setPwd(dbObject.get("password").toString());
					shop.setRadius(dbObject.get("radius").toString());
				}else {
					return null;
				}
			}
		}catch(Exception e){
			System.out.println("数据库连接失败");
			return null;
		}
		return shop;
	}

	
	public static void main(String[] args) {
		Shop shop = new Shop("test", "test", "ssd","wotest", "123", "dsfasdf", "sdf");
		IShopDao sd = new ShopDaoImpl();
		sd.addShop(shop);
		
		System.out.println(sd.shopLogin("nike", "12345678"));
		
	}
}
