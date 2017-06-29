package com.crw.wifiAnalysis.dao.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.crw.wifiAnalysis.utils.MongoDBUtil;
import com.cxw.wifiAnalysis.dao.IFlowDao;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.QueryOperators;

public class FlowDaoImpl implements IFlowDao{

	@Override
	public DBObject findByDate(String mmac, String day) {
		DB db = MongoDBUtil.getDb();
		DBCollection collection = db.getCollection("dayly");
		DBObject dbObject=null;
		//匹配
		//临时条件对象：
		BasicDBObject cond = null;
		cond = new BasicDBObject();
		cond.put("mmac", mmac);
		cond.put("day", day);
		
		DBCursor cursor = collection.find(cond);
		if(cursor.hasNext()){
			dbObject=cursor.next();
		}
		return dbObject;
	}

	@Override
	public DBObject[] findByDate(String mmac, List<String> list) {
		/*DB db = MongoDBUtil.getDb();
		DBCollection collection = db.getCollection("dayly");
		DBObject[] dbObject=new DBObject[list.size()];
		BasicDBObject conddb = new BasicDBObject();
		//匹配
		//临时条件对象：
		BasicDBObject cond = new BasicDBObject();    //条件1
		cond.put("mmac", mmac);
		BasicDBObject[] condday = new BasicDBObject[list.size()]; //条件2
		for (int i = 0; i < list.size(); i++) {
			condday[i] = new BasicDBObject().append("day", list.get(i));
		}
		BasicDBObject[] condition = new BasicDBObject[list.size()+1];
		condition[0] = cond;
		for (int j = 1; j < list.size()+1; j++) {
			condition[j] = condday[j-1];
		}
		
		conddb.append(QueryOperators.AND, condition);
		
		DBCursor cursor = collection.find(conddb);
		int num=0;
		while(cursor.hasNext()){
			dbObject[num] = new BasicDBObject();
			dbObject[num]=cursor.next();
			System.out.println(dbObject[num]);
			num++;
		}
		*/
		DBObject[] dbObject = new BasicDBObject[list.size()];
		for (int i = 0; i < list.size(); i++) {
			dbObject[i] = new BasicDBObject();
			dbObject[i] = findByDate(mmac, list.get(i));
		}
		
		return dbObject;
	}

}
