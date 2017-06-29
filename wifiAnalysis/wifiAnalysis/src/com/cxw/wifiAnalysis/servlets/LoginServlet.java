package com.cxw.wifiAnalysis.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.crw.wifiAnalysis.dao.impl.ShopDaoImpl;
import com.crw.wifiAnalysis.entity.Shop;
import com.cxw.wifiAnalysis.dao.IShopDao;

public class LoginServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		resp.setCharacterEncoding("utf-8");
		
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		
		IShopDao sDao = new ShopDaoImpl();
		Shop shop = sDao.shopLogin(username, password);
		
		HttpSession session = req.getSession();
		PrintWriter out = resp.getWriter();
		int result=0;
		
		
		if(shop.getId()==null){
			result=0;
		}else {
			session.setAttribute("shop", shop);
			result=1;
		}
		out.println(result);
		out.flush();
		out.close();
	}
}
