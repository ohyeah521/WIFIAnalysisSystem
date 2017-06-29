package com.cxw.wifiAnalysis.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.crw.wifiAnalysis.dao.impl.ShopDaoImpl;
import com.crw.wifiAnalysis.entity.Shop;
import com.cxw.wifiAnalysis.dao.IShopDao;

public class RegisterServlet extends HttpServlet{

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
		
		String id = req.getParameter("ID");
		String mmac= req.getParameter("mmac");
		String name= req.getParameter("name");
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		String address= req.getParameter("address");
		String radius = req.getParameter("radius");
		
		Shop shop = new Shop(id, mmac, name, username,password, address, radius);
		IShopDao sDao = new ShopDaoImpl();
		
		int result = sDao.addShop(shop);

		req.setAttribute("result", result);
		req.getRequestDispatcher("result.jsp").forward(req, resp);
	}
}
