package com.crw.wifiAnalysis.utils;

import com.mongodb.DB;
import com.mongodb.Mongo;
import com.mongodb.MongoException;

public class MongoDBUtil {
	public static final String DBName = "wifiAnalysis";
	public static final String ServerAddress = "192.168.63.110";
	public static final int PORT = 27017;

	private static Mongo m = null;
	private static DB db = null;

	public MongoDBUtil() {
	}

	public static DB getDb(){
		startMongoDBConn();
		return db;
	}
	/**
	 * 关闭mongodb数据库连接
	 */
	private static void stopMondoDBConn() {
		if (null != m) {
			try {
				m.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			m = null;
			db = null;
		}
	}

	/**
	 * 获取mongodb数据库连接
	 */
	private static void startMongoDBConn() {
		try {
			// Mongo(p1, p2):p1=>IP地址 p2=>端口
			m = new Mongo(ServerAddress, PORT);
			// 根据mongodb数据库的名称获取mongodb对象
			db = m.getDB(DBName);
		} catch (MongoException e) {
			e.printStackTrace();
		}
	}

}
