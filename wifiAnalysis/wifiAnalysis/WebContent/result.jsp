<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>注册结果展示</title>
  <script type="text/javascript" src="http://cdn.jsdelivr.net/jquery/1/jquery.min.js"></script>
  <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css"> 
  <script type="text/javascript" src="http://netdna.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
</head>
<body>
  <div style="text-align:center; width:800px;height:300px; position:absolute; left:50%; top:50%; margin:-150px 0 0 -400px;  ">
  <span class="label label-success" id="result" style="font-size:40px;"></span><br>
  <a class="btn btn-info" href="" role="button" id="rebtn" style="margin-top:30px;"></a>
  </div>
  
  
  <script type="text/javascript">
  <% int count = (int)request.getAttribute("result"); %>
  var result =<%=count%> ;
  $("#result").removeClass();
  if(result==0){
    $("#result").addClass("label label-warning");
    $("#result").text("注册失败！改店铺已注册！");
    $("#rebtn").text("重新注册");
    $("#rebtn").attr("href","register.html");
  }else if(result==1){
    $("#result").addClass("label label-success");
    $("#result").text("注册成功！！！");
    $("#rebtn").text("返回登录");
    $("#rebtn").attr("href","login.html");
  }else if(result==2){
    $("#result").addClass("label label-danger");
    $("#result").text("数据库连接失败！！！");
    $("#rebtn").text("联系我们");
    $("#rebtn").attr("href","");
  }
   
  </script>
</body>
</html>