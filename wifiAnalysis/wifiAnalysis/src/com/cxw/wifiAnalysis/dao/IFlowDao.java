package com.cxw.wifiAnalysis.dao;

import java.util.List;

import com.mongodb.DBObject;

public interface IFlowDao {
	/**
	 * 通过天查询客流数据
	 * @param mmac
	 * @param day
	 * @return
	 */
	public DBObject findByDate(String mmac,String day);
	
	/**
	 * 通过天查询多条客流数据
	 * @param mmac
	 * @param list
	 * @return
	 */
	public DBObject[] findByDate(String mmac,List<String> list);
}
