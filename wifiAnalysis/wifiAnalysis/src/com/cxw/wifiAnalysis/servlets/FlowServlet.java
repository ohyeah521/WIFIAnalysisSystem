package com.cxw.wifiAnalysis.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.jdt.internal.compiler.ast.ThisReference;

import com.crw.wifiAnalysis.dao.impl.FlowDaoImpl;
import com.cxw.wifiAnalysis.dao.IFlowDao;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mongodb.DBObject;

public class FlowServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		resp.setCharacterEncoding("utf-8");
		
		String op = req.getParameter("op");
		if("hour".equals(op)){
			hourFlow(req,resp);
		}else if("day".equals(op)){
			dayFlow(req,resp);
		}else if("week".equals(op)){
			weekFlow(req,resp);
		}else if("month".equals(op)){
			monthFlow(req,resp);
		}
	}


	private void monthFlow(HttpServletRequest req, HttpServletResponse resp) {
		// TODO Auto-generated method stub
		
	}


	private void weekFlow(HttpServletRequest req, HttpServletResponse resp) {
		// TODO Auto-generated method stub
		
	}


	private void dayFlow(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String mmac = req.getParameter("mmac");
		String startday = req.getParameter("startday");
		String endday = req.getParameter("endday");
		int days = Integer.parseInt(req.getParameter("days"));
		
		List<String> dayList = new ArrayList<String>();
		for (int i = 0; i < days; i++) {
			dayList.add(startday);
			startday = this.getSpecifiedDayAfter(startday);
		}
		
		IFlowDao flowDao = new FlowDaoImpl();
		DBObject[] dbObject = flowDao.findByDate(mmac, dayList);
		
		PrintWriter out = resp.getWriter();
		if(dbObject==null){
			out.println("");
		}else{
			Map<String, Integer> areaMap = new HashMap<String, Integer>();  //每日客流量
			Map<String, Integer> shopMap = new HashMap<String, Integer>();  //每日入店量
			Map<String, Integer> areaTotalMap = new HashMap<String, Integer>();  //总客流量
			Map<String, Integer> shopTotalMap = new HashMap<String, Integer>();  //总入店量
			
			int areaOneDay = 0;  //每日客流量
			int shopOneDay = 0;  //每日入店量
			int areaTotal = 0;  //总客流量
			int shopTotal = 0;  //总入店量
			for(int i = 0 ; i < days; i++){
				DBObject dayObject = (DBObject) ((DBObject) dbObject[i].get("flow")).get("total");
				areaOneDay = Integer.parseInt(dayObject.get("in_area").toString());
				shopOneDay = Integer.parseInt(dayObject.get("in_shop").toString());
				areaMap.put(dayList.get(i), areaOneDay);
				shopMap.put(dayList.get(i), shopOneDay);
				areaTotal +=areaOneDay;
				shopTotal +=shopOneDay;
			}
			
			areaTotalMap.put("areaTotal", areaTotal);
			shopTotalMap.put("shopTotal", shopTotal);
			List<Map<String,Integer>> list = new ArrayList<Map<String,Integer>>();
			list.add(areaMap);
			list.add(shopMap);
			list.add(areaTotalMap);
			list.add(shopTotalMap);
			
			Gson gson = new GsonBuilder().create();
			out.println(gson.toJson(list));
		}
	}


	private void hourFlow(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String mmac = req.getParameter("mmac");
		String day = req.getParameter("day");
		int start = Integer.parseInt(req.getParameter("start"));
		int end = Integer.parseInt(req.getParameter("end"));
		
		IFlowDao flowDao = new FlowDaoImpl();
		DBObject dbObject = flowDao.findByDate(mmac, day);
		
		//System.out.println(dbObject);
		PrintWriter out = resp.getWriter();
		if(dbObject==null){
			out.println("");
		}else{
			Map<Integer, Integer> areaMap = new HashMap<Integer, Integer>();  //每小时客流量
			Map<Integer, Integer> shopMap = new HashMap<Integer, Integer>();  //每小时入店量
			Map<Integer, Integer> areaTotalMap = new HashMap<Integer, Integer>();  //总客流量
			Map<Integer, Integer> shopTotalMap = new HashMap<Integer, Integer>();  //总入店量
			
			DBObject flow = (DBObject) dbObject.get("flow");
			DBObject metrics = (DBObject) flow.get("metrics");
			DBObject count;
			
			int areaOneHour = 0;  //每小时客流量
			int shopOneHour = 0;  //每小时入店量
			int areaTotal = 0;  //总客流量
			int shopTotal = 0;  //总入店量
			
			for(int i=start;i<=end;i++){
				count = (DBObject) metrics.get(""+i);
				areaOneHour = Integer.parseInt(count.get("in_area").toString());
				shopOneHour = Integer.parseInt(count.get("in_shop").toString());
				areaMap.put(i, areaOneHour);
				shopMap.put(i, shopOneHour );
				areaTotal +=areaOneHour;
				shopTotal +=shopOneHour;
			}
			areaTotalMap.put(100, areaTotal);
			shopTotalMap.put(101, shopTotal);
			List<Map<Integer,Integer>> list = new ArrayList<Map<Integer,Integer>>();
			list.add(areaMap);
			list.add(shopMap);
			list.add(areaTotalMap);
			list.add(shopTotalMap);
			
			Gson gson = new GsonBuilder().create();
			out.println(gson.toJson(list));
			
		}
		
	}
	
	/**
	 * 
	 * 获取当前日期的后一天日期
	 * @param specifiedDay
	 * @return
	 */
	 public String getSpecifiedDayAfter(String specifiedDay) {  
	        Calendar c = Calendar.getInstance();  
	        Date date = null;  
	        try {  
	            date = new SimpleDateFormat("yyyy-MM-dd").parse(specifiedDay);  
	        } catch (Exception e) {  
	            e.printStackTrace();  
	        }  
	        c.setTime(date);  
	        int day = c.get(Calendar.DATE);  
	        c.set(Calendar.DATE, day + 1);  
	  
	        String dayAfter = new SimpleDateFormat("yyyy-MM-dd")  
	                .format(c.getTime());  
	        return dayAfter;  
	    }  
}
