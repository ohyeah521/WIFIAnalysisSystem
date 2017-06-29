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

<!-- table -->
<link href="http://cdn.bootcss.com/bootstrap-table/1.9.1/bootstrap-table.min.css" rel="stylesheet"/> 
<script src="http://cdn.bootcss.com/bootstrap-table/1.9.1/bootstrap-table.min.js"></script>
<script src="http://cdn.bootcss.com/bootstrap-table/1.9.1/locale/bootstrap-table-zh-CN.min.js"></script>

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
       <a href="#">顾客</a> <span class="divider">/</span>
       顾客信息
    </ul>
   
    <div class="title_right">
      <strong style="font-size:16px">顾客信息：</strong>
      <span class="label" style="font-size:14px;">沉睡活跃度</span>
      <span class="label label-info" style="font-size:14px;">低活跃度</span>
      <span class="label label-warning" style="font-size:14px;">中活跃度</span>
      <span class="label label-danger" style="font-size:14px;">高活跃度</span>
      <span class="label label-primary" style="font-size:14px;" data-toggle="modal" data-target="#timeSet">设置</span>

      <div class="modal fade" id="timeSet" tabindex="-1" role="document" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document" >
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">顾客活跃度设置</h4>
          </div>
          <div class="modal-body" style="height:170px;">
            <ul>
              <li style="list-style-type:none;float:left;"><p style="font-size:14px;display:inline-block;">高活跃度：</p></li>
              <li style="list-style-type:none;"><input type="text" value="0" style="height:25px;width:30px;" />-<input type="text" value="3" style="height:25px;width:30px;" />天数</li>
              <li style="list-style-type:none;margin-top:10px;"><p style="font-size:14px;display:inline-block;">中活跃度：</p><input type="text" value="3" style="height:25px;width:30px;" />-<input type="text" value="10" style="height:25px;width:30px;" />天数</li>
              <li style="list-style-type:none;margin-top:10px;"><p style="font-size:14px;display:inline-block;">低活跃度：</p><input type="text" value="10" style="height:25px;width:30px;" />-<input type="text" value="30" style="height:25px;width:30px;" />天数</li>
              <li style="list-style-type:none;margin-top:10px;"><p style="font-size:14px;display:inline-block;">沉睡活跃度：</p>大于<input type="text" value="30" style="height:25px;width:30px;" />天数</li>
            </ul>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            <button type="button" class="btn btn-primary" onclick="">确定</button>
          </div>
        </div>
      </div>
      </div>
    </div> 
    <table class="table table-hover">
      <tbody>
        <tr class="active">
          <td >id</td>
          <td >mac</td>
          <td >来访周期</td>
          <td >入店次数</td>
          <td >状态</td>
          <td >驻店时长</td>
        </tr>
        <tr class="danger">
          <td >1</td>
          <td >fc:d7:33:63:6c:c4</td>
          <td >1 days, 00:10:42</td>
          <td >21</td>
          <td >1</td>
          <td >0:00:12</td>
        </tr>
        <tr class="danger">
          <td >2</td>
          <td >00:01:7a:aa:bb:cc</td>
          <td >1 days, 00:15:00</td>
          <td >15</td>
          <td >1</td>
          <td >0:06:12</td>
        </tr>
        <tr class="warning">
          <td >3</td>
          <td >aa:d7:33:63:6c:dd</td>
          <td >3 days, 18:55:44</td>
          <td >6</td>
          <td >0</td>
          <td >0:30:12</td>
        </tr>
        <tr class="warning">
          <td >4</td>
          <td >fc:d6:33:55:46:34</td>
          <td >5 days, 15:33:42</td>
          <td >7</td>
          <td >0</td>
          <td >0:10:12</td>
        </tr>
        <tr class="warning">
          <td >5</td>
          <td >bb:b7:33:d4:ee:b4</td>
          <td >7 days, 10:41:10</td>
          <td >5</td>
          <td >0</td>
          <td >0:08:12</td>
        </tr>
        <tr class="info">
          <td >6</td>
          <td >ac:33:00:t3:6c:a3</td>
          <td >10 days, 22:11:02</td>
          <td >4</td>
          <td >0</td>
          <td >0:05:12</td>
        </tr>
        <tr class="info">
          <td >7</td>
          <td >44:d7:45:63:55:c4</td>
          <td >11 days, 15:23:42</td>
          <td >4</td>
          <td >0</td>
          <td >0:15:12</td>
        </tr>
        <tr class="info">
          <td >8</td>
          <td >88:d7:33:45:11:d2</td>
          <td >15 days, 20:49:42</td>
          <td >3</td>
          <td >0</td>
          <td >0:33:12</td>
        </tr>
        <tr class="active">
          <td >9</td>
          <td >00:d7:k4:66:66:f4</td>
          <td >50 days, 01:44:42</td>
          <td >2</td>
          <td >0</td>
          <td >0:01:44</td>
        </tr>
        <tr class="active">
          <td >10</td>
          <td >35:d7:44:22:33:77</td>
          <td >132 days, 00:49:42</td>
          <td >1</td>
          <td >0</td>
          <td >0:01:41</td>
        </tr>
        </tbody>        
    </table>
    <div style="width: 100%px;height:40px;">
    <ul class="pagination pagination-sm" style="float:right;margin-top:5px; margin-right:20px;">
        <li><a href="#">&laquo;</a></li>
        <li class="active"><a href="#">1</a></li>
        <li class="disabled"><a href="#">2</a></li>
        <li><a href="#">3</a></li>
        <li><a href="#">4</a></li>
        <li><a href="#">5</a></li>
        <li><a href="#">&raquo;</a></li>
    </ul>
    </div>
    
    <div id="main-custmoer" style="width: 100%px;height:300px;background-color:lightblue;margin-top:10px;"></div>
    <div id="main-trace" style="width: 100%px;height:300px;background-color:lightblue;margin-top:10px;"></div>

    </div>  
  </div>     
</div>
</div>

<script type="text/javascript">
$(function(){
  // 基于准备好的dom，初始化echarts实例
  var myChart = echarts.init(document.getElementById('main-custmoer'));
  // 指定图表的配置项和数据
  option = {
    title : {
        text: '新老顾客占比',
        x:'center'
    },
    tooltip : {
        trigger: 'item',
        formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient: 'vertical',
        left: 'left',
        data: ['新顾客','老顾客']
    },
    series : [
        {
            name: '访问来源',
            type: 'pie',
            radius : '55%',
            center: ['50%', '60%'],
            data:[
                {value:3334, name:'新顾客'},
                {value:1005, name:'老顾客'}
            ],
            itemStyle: {
                emphasis: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    ]
};
  // 使用刚指定的配置项和数据显示图表。
  myChart.setOption(option);
});

$(function(){
  // 基于准备好的dom，初始化echarts实例
  var myChart = echarts.init(document.getElementById('main-trace'));
  // 指定图表的配置项和数据
  option = {
    title : {
        text: '顾客轨迹跟踪',
        x:'center'
    },
    tooltip : {
        trigger: 'item',
        formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient: 'vertical',
        left: 'left',
        data: ['跳出','深访']
    },
    series : [
        {
            name: '访问来源',
            type: 'pie',
            radius : '55%',
            center: ['50%', '60%'],
            data:[
                {value:15664, name:'跳出'},
                {value:1005, name:'深访'}
            ],
            itemStyle: {
                emphasis: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    ]
};
  // 使用刚指定的配置项和数据显示图表。
  myChart.setOption(option);
});


</script>




 
</body>
</html>
