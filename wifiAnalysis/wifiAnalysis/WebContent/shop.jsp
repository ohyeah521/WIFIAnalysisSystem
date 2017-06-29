<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Wifi探针数据分析系统</title>

<link rel="stylesheet" href="css/bootstrap.css" />
<link rel="stylesheet" href="css/css.css" />
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/sdmenu.js"></script>
<script type="text/javascript" src="js/echarts.js"></script>

<link rel="stylesheet" href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css"/>
<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<!-- Include Required Prerequisites -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/bootstrap/3/css/bootstrap.css" />
 
<!-- Include Date Range Picker -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/bootstrap.daterangepicker/2/daterangepicker.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/bootstrap.daterangepicker/2/daterangepicker.css" />

</head>

<body>
<div class="header">
	 <div class="logo"><img  src="img/logo.png" /></div>
		<div class="header-right">
		            <i class="icon-question-sign icon-white"></i> <a href="#">帮助</a> <i class="icon-off icon-white"></i> <a id="a_myModal" href="#myModal" role="button" data-toggle="modal">注销</a> <i class="icon-user icon-white"></i> <a href="#">店铺:${shop.name }</a> <i class="icon-envelope icon-white"></i> <a href="#">发送短信</a>
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  <div class="modal-dialog" role="document" >
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title">注销系统</h4>
		      </div>
		      <div class="modal-body">
		        <p>你确定要注销系统吗？</p>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		        <button type="button" class="btn btn-primary" onclick="quit()">确定退出</button>
		      </div>
		    </div>
		  </div>
		</div>
	</div>
</div>
            
<script type="text/javascript">
	function quit(){
		location.href="login.html";
	}
</script>  
            
<div id="middle">
<div class="left1">
     
<script type="text/javascript">
	var myMenu;
	window.onload = function() {
		myMenu = new SDMenu("my_menu");
		myMenu.init();
	};
</script>

<div id="my_menu" class="sdmenu">
    <div class="collapsed">
    <span>店铺探针管理</span>
    <a href="shop.jsp">店铺设置</a>
  </div>
  <div >
    <span>客流</span>
    <a href="index.jsp">客流信息</a>
  </div>
  <div class="collapsed">
    <span>顾客</span>
     <a href="customer.jsp">顾客信息</a>
  </div>
</div>

     </div>
     <div class="Switch"></div>
<script type="text/javascript">
	$(document).ready(function(e) {
    $(".Switch").click(function(){
	$(".left1").toggle();
	 
		});
});
</script>


   <div class="right"  id="mainFrame">
     
    <div class="right_cont">
		<ul class="breadcrumb">
		&nbsp;&nbsp;&nbsp;当前位置：
 			 <a href="index.jsp">首页</a> <span class="divider">/</span>
 			 <a href="shop.html">店铺设置</a>
		</ul>
   
	<form class="form-horizontal" id="registerForm" action="registerServlet" method="post">
    <fieldset>
      <div id="legend" class="">
        <legend class="">店铺详情</legend>
      </div>
 
    <div class="form-group">

          <!-- 文本输入 -->
          <label class="control-label col-md-3" for="input01">店铺探针ID</label>
          <div class="controls col-md-6">
            <input placeholder="" class="form-control" type="text" name="ID" id="ID" value="${shop.id }"/>
            <span style="color:red;" id="span_ID"></span>
          </div>
        </div>

    <div class="form-group">

          <!-- 文本输入 -->
          <label class="control-label col-md-3" for="input01">mmac</label>
          <div class="controls col-md-6">
            <input placeholder="" class="form-control" type="text" name="mmac" id="mmac" value="${shop.mmac }"/>
            <span style="color:red;" id="span_mmac"></span>
          </div>
        </div>
    <div class="form-group">

          <!-- 文本输入 -->
          <label class="control-label col-md-3" for="input01">店铺名</label>
          <div class="controls col-md-6">
            <input placeholder="" class="form-control" type="text" name="name" id="name" value="${shop.name }"/>
            <span style="color:red;" id="span_name"></span>
          </div>
    </div>
    
    <div class="form-group">

          <!-- 文本输入 -->
          <label class="control-label col-md-3" for="input01">账号/手机号</label>
          <div class="controls col-md-6">
            <input placeholder="" class="form-control" type="text" name="username" id="username" value="${shop.username }"/>
            <span style="color:red;" id="span_username"></span>
          </div>
    </div>
    

    <div class="form-group">

          <!-- 文本输入 -->
          <label class="control-label col-md-3" for="input01">密码</label>
          <div class="controls col-md-6">
            <input placeholder="" class="form-control" type="password" name="password" id="password" value="${shop.pwd }"/>
            <span style="color:red;" id="span_password"></span>
          </div>
        </div>

    <div class="form-group">

          <!-- 文本输入 -->
          <label class="control-label col-md-3" for="input01">Address</label>
          <div class="controls col-md-6">
            <input placeholder="" class="form-control" type="text" name="address" id="address" value="${shop.addr }"/>
            <span style="color:red;" id="span_address"></span>
          </div>
        </div>

    <div class="form-group">

          <!-- 文本输入 -->
          <label class="control-label col-md-3" for="input01">Radius</label>
          <div class="controls col-md-6">
            <input placeholder="" class="form-control" type="text" name="radius" id="radius" value="${shop.radius }"/>
            <span style="color:red;" id="span_radius"></span>
          </div>
        </div>

    <div class="form-group">
          <!-- 按钮 -->
          <div class="controls col-md-offset-3 col-md-6">
            <button class="btn btn-success" onclick="return register()">修改</button>
            <button type="reset" class="btn btn-success" style="margin-left:30px;">重置</button>      
          </div>
    </div>

    </fieldset>
  </form>


   </div>
</div>
</div>
	


  <script type="text/javascript">
      function register(){
        var id = $("#ID").val();
        var mmac= $("#mmac").val();
        var name= $("#name").val();
        var username = $("#username").val();
        var password = $("#password").val();
        var address= $("#address").val();
        var radius = $("#radius").val();


     	$("#span_ID").text("");
        $("#span_mmac").text("");
        $("#span_name").text("");
        $("#span_username").text("");
        $("#span_password").text("");
        $("#span_address").text(""); 

        if(id==""||id==null){
            $("#span_ID").text("ID不能为空");
            return false;
        } if(mmac==""||mmac==null){ 
            $("#span_mmac").text("mmac不能为空");
            return false;
        }
         if(name==""||name==null){
            $("#span_name").text("店铺名不能为空");
            return false;
        }
         if(username==""||username==null){
        	$("#span_username").text("手机号不能为空");
            return false;
        }
         if(password==""||password==null){           
            $("#span_password").text("密码不能为空");
            return false;
        }
         if(address==""||address==null){           
            $("#span_address").text("Address不能为空");
            return false;
        }
         if(radius==""||radius==null){     
            $("#span_radius").text("Radius不能为空");
            return false;
        }
        $("#registerForm").submit();
        
      }

  </script>

</body>
</html>