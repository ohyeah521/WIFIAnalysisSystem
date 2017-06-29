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
 			 <a href="#">首页</a> <span class="divider">/</span>
 			 <a href="#">客流</a> <span class="divider">/</span>
 			 客流趋势
		</ul>
   
    <div class="title_right">
   		<strong style="font-size:16px">分析维度：</strong>
  		<div class="btn-group btn-group-xs" role="group" aria-label="...">
  			<button type="button" class="btn btn-default" data-toggle="collapse" data-target="#collapse-hour" aria-expanded="false" aria-controls="collapse-hour">时</button>
			<button onclick="queryByDay()" type="button" class="btn btn-default" data-toggle="collapse" data-target="#collapse-day" aria-expanded="false" aria-controls="collapse-day">日</button>
 			<button onclick="" type="button" class="btn btn-default" data-toggle="collapse" data-target="#collapse-week" aria-expanded="false" aria-controls="collapse-week">周</button>
 			<button onclick="" type="button" class="btn btn-default" data-toggle="collapse" data-target="#collapse-month" aria-expanded="false" aria-controls="collapse-month">月</button>
		</div>

	</div> 


	<div class="collapse in" id="collapse-hour">

	<div>
		 <p style="font-size:18px; line-height:30px;">当前分析维度：小时</p>
	</div>
	<div style="height:30px;margin-top:5px;">
		 <p style="font-size:18px; line-height:30px; color:white;background-color:lightblue;">客流信息</p>
	</div>
	<div style="margin-top:5px;">
	 	<ul>
	 		<li style="list-style-type:none;float:left;"><p style="font-size:14px; line-height:34px;">数据时间：</p></li>
	 		<li style="list-style-type:none;">
	 		<input type="text" id="showCalender" name="daterange-hour-day" value="" style="height:25px;width:100px;" />
	 		<input type="text" id="closeCalender" name="daterange-hour-hour" value="" style="height:25px;width:130px;" />
	 		<button class="btn btn-default" onclick="queryByHour()" style="margin-left:2px;">查询</button></li>
	 		<li style="list-style-type:none;margin-top:10px;"><p style="font-size:14px;">总客流量：<a id="areaTotal">0</a>&nbsp;人次</p></li>
	 		<li style="list-style-type:none;margin-top:10px;"><p style="font-size:14px;">总入店量：<a id="shopTotal">0</a>&nbsp;人次</p></li>
	 	</ul>
	</div>

	<div style="height:30px;margin-top:5px;">
		 <p style="font-size:18px; line-height:30px; color:white;background-color:lightblue;">客流趋势</p>
	 </div>
	 <div id="main-hour" style="width: 100%px;height:400px;background-color:lightblue;margin-top:10px;"></div>
	 <div class="title_right"></div>
	</div><!--小时-->


	<div class="collapse" id="collapse-day">
	<div>
		 <p style="font-size:18px; line-height:30px;">当前分析维度：日</p>
	</div>
	<div style="height:30px;margin-top:5px;">
		 <p style="font-size:18px; line-height:30px; color:white;background-color:lightblue;">客流信息</p>
	</div>
	<div style="margin-top:5px;">
	 	<ul>
	 		<li style="list-style-type:none;float:left;"><p style="font-size:14px; line-height:34px;">数据时间：</p></li>
	 		<li style="list-style-type:none;">
	 		<input type="text" id="showCalender-day" name="daterange-day" value="" style="height:25px;width:200px;" />
	 		<button class="btn btn-default" onclick="queryByDay()" style="margin-left:2px;">查询</button></li>
	 		<li style="list-style-type:none;margin-top:10px;"><p style="font-size:14px;">总客流量：<a id="areaTotal-day">0</a>&nbsp;人次</p></li>
	 		<li style="list-style-type:none;margin-top:10px;"><p style="font-size:14px;">总入店量：<a id="shopTotal-day">0</a>&nbsp;人次</p></li>
	 	</ul>
	</div>

	<div style="height:30px;margin-top:5px;">
		 <p style="font-size:18px; line-height:30px; color:white;background-color:lightblue;">客流趋势</p>
	 </div>
	 <div id="main-day" style="width: 100%px;height:400px;background-color:lightblue;margin-top:10px;"></div>
	 <div class="title_right"></div>
	</div><!--天-->


	<div class="collapse" id="collapse-week">
	<div>
		 <p style="font-size:16px; ">当前分析维度：周</p>
	</div>
	 <div>
		 <p style="font-size:16px; ">客流信息</p>
	 </div>
	 <div>
	 	<ul>
	 		<li style="list-style-type:none;float:left;"><p style="font-size:14px;">数据时间：</p></li>
	 		<li style="list-style-type:none;"><input type="text" name="daterange" value="2017-06-20 1:30 - 2017-06-20 1:30" style="height:25px;width:260px;" /><button>查询</button></li>
	 		<li style="list-style-type:none;margin-top:5px;"><p style="font-size:14px;">总客流量：666&nbsp;人次</p></li>
	 		<li style="list-style-type:none;margin-top:5px;"><p style="font-size:14px;">总入店量：100&nbsp;人次</p></li>
	 	</ul>
	 </div>

	<div>
		 <p style="font-size:16px; ">客流趋势</p>
	 </div>
	 <div>
	 	图
	 </div>


	 <div id="comeshop">
		 <p style="font-size:16px; ">入店趋势</p>
	 </div>
	 <div>
	 	图
	 </div>
	 <div class="title_right"></div>
	</div><!--周-->


	<div class="collapse" id="collapse-month">
	<div>
		 <p style="font-size:16px; ">当前分析维度：月</p>
	</div>
	 <div>
		 <p style="font-size:16px; ">客流信息</p>
	 </div>
	 <div>
	 	<ul>
	 		<li style="list-style-type:none;float:left;"><p style="font-size:14px;">数据时间：</p></li>
	 		<li style="list-style-type:none;"><input type="text" name="daterange" value="2017-06-20 1:30 - 2017-06-20 1:30" style="height:25px;width:260px;" /><button>查询</button></li>
	 		<li style="list-style-type:none;margin-top:5px;"><p style="font-size:14px;">总客流量：666&nbsp;人次</p></li>
	 		<li style="list-style-type:none;margin-top:5px;"><p style="font-size:14px;">总入店量：100&nbsp;人次</p></li>
	 	</ul>
	 </div>

	<div>
		 <p style="font-size:16px; ">客流趋势</p>
	 </div>
	 <div>
	 	图
	 </div>


	 <div id="comeshop">
		 <p style="font-size:16px; ">入店趋势</p>
	 </div>
	 <div>
	 	图
	 </div>
	 <div class="title_right"></div>
	</div><!--月-->

   	
  	</div>  
  </div>     
</div>
</div>

<script type="text/javascript">
$("#showCalender").click(function(){
	 $('.calendar-table').css("display","block");//显示div
});

$("#showCalender-day").click(function(){
	 $('.calendar-table').css("display","block");//显示div
});

$("#closeCalender").click(function(){
	 $('.calendar-table').css("display","none");//隐藏div
});

//日期选择器 hour-day
$(function() {
    $('input[name="daterange-hour-day"]').daterangepicker({
    	singleDatePicker:true,
        locale: {
            format: 'YYYY-MM-DD'
        }
    });
   
});

//日期选择器 hour
$(function() {
    $('input[name="daterange-hour-hour"]').daterangepicker({
    	timePicker:true,
    	timePicker24Hour:true,
    	timePickerIncrement:60,
    	showDropdowns:false,
        locale: {
            format: 'HH:mm'
        }
    });
});

//日期选择器day
$(function(){
	$('input[name="daterange-day"]').daterangepicker({
		locale:{
			format: 'YYYY-MM-DD'
		}
	});
});

//显示实时数据
$(function(){
	queryByHour();
});

//取数组中的最大值
function maxnum(array){
	return Math.max.apply(null,array);
}

function queryByHour(){
	var mmac = "${shop.mmac}";
	var day = $("input[name='daterange-hour-day']").val();
	var hoursText = $("input[name='daterange-hour-hour']").val();
	var hours = hoursText.split('-');
	var start = parseInt(hours[0]);
	var end = parseInt(hours[1]);
	if(start>end){
		alert("时间范围有错，请重新选择！");
		return;
	}
	$.post("flowServlet",{op:"hour",mmac:mmac,day:day,start:start,end:end},function(data){
		var datalen = end-start+1;   //数据个数
		var xdata = new Array(datalen);  //指定x坐标的范围
		var areadata = new Array(datalen);    //客流量
		var shopdata = new Array(datalen);	  //入店量
		var ratedata = new Array(datalen);    //入店率
		var num = 1000;   //y坐标顾客数
		
		if(data==0){
			for(var i =0; i<xdata.length; i++){
				xdata[i]=start+i;
			}
		}else{ 
			var dataObj = $.parseJSON(data);
			//alert(JSON.stringify(dataObj[0][start]));
			$("#areaTotal").text(JSON.stringify(dataObj[2][100]));
			$("#shopTotal").text(JSON.stringify(dataObj[3][101]));
			
			for(var i =0; i<xdata.length; i++){
				xdata[i]=start+i;
				areadata[i] = parseFloat(JSON.stringify(dataObj[0][start+i]));
				shopdata[i] = parseFloat(JSON.stringify(dataObj[1][start+i]));
				ratedata[i] = (shopdata[i]/areadata[i]*100).toFixed(2);
			}
			
			num=Math.ceil(maxnum(areadata)*1.5/100)*100;
			
		}
		
		// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main-hour'));
        // 指定图表的配置项和数据
        option = createChart(xdata,areadata,shopdata,ratedata,num);

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
			
	});
}

function queryByDay(){
	var mmac = "${shop.mmac}";
	var day = $("input[name='daterange-day']").val();
	var startday = day.substr(0,10);
	var endday = day.substr(13,10);
	
	var start = new Date(Date.parse(startday));  //开始日期
	var end = new Date(Date.parse(endday));		 //结束日期
	var time=end.getTime()-start.getTime();
	var datalen = parseInt(time/(1000 * 60 * 60 * 24))+1;   //数据个数
	
	//alert(new Date(Date.parse(startday)));
	//var startday = day.split(' - ');
	$.post("flowServlet",{op:"day",mmac:mmac,startday:startday,endday:endday,days:datalen},function(data){

		var xdata = new Array(datalen);  //指定x坐标的范围
		var areadata = new Array(datalen);    //客流量
		var shopdata = new Array(datalen);	  //入店量
		var ratedata = new Array(datalen);    //入店率
		var num = 1000;   //y坐标顾客数
		if(data==0){
			for(var i =0; i<xdata.length; i++){
				start.setDate(start.getDate()+i);
				xdata[i]=start.getFullYear()+"-"+(start.getMonth()+1)+"-"+start.getDate();
			}
		}else{
			var dataObj = $.parseJSON(data);
			//alert(JSON.stringify(dataObj));
			$("#areaTotal-day").text(JSON.stringify(dataObj[2].areaTotal));
			$("#shopTotal-day").text(JSON.stringify(dataObj[3].shopTotal));
		    var dataArr = []; //声明数组
		    for(var i=0,j=0,l=2;i<l;i++){
		    	j=0;
		    	dataArr[i] = new Array();  //声明二维数组
		    	for(var key in dataObj[i]){
		    		dataArr[i][j]=dataObj[i][key]; //初始化
		    		j++;
		    	}
		    }
			
			for(var i =0; i<xdata.length; i++){
				xdata[i]=start.getFullYear()+"-"+(start.getMonth()+1)+"-"+start.getDate();
				start.setDate(start.getDate()+1);
				areadata[i] = parseFloat(dataArr[0][i]);
				shopdata[i] = parseFloat(dataArr[1][i]);
				ratedata[i] = (shopdata[i]/areadata[i]*100).toFixed(2);
			}
			
			num=Math.ceil(maxnum(areadata)*1.5/100)*100;
		}
		
		// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main-day'));
        // 指定图表的配置项和数据
        option = createChart(xdata,areadata,shopdata,ratedata,num);

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
	});
}

//绘制报表
function createChart(xdata,areadata,shopdata,ratedata,num){
	return option = {
		    tooltip: {
		        trigger: 'axis',
		        axisPointer: {
		            type: 'cross',
		            crossStyle: {
		                color: '#999'
		            }
		        }
		    },
		    toolbox: {
		        feature: {
		            dataView: {show: true, readOnly: false},
		            magicType: {show: true, type: ['line', 'bar']},
		            restore: {show: true},
		            saveAsImage: {show: true}
		        }
		    },
		    legend: {
		        data:['客流量','入店量','入店率']
		    },
		    xAxis: [
		        {
		            type: 'category',
		            data: xdata,
		            axisPointer: {
		                type: 'shadow'
		            }
		        }
		    ],
		    yAxis: [
		        {
		            type: 'value',
		            name: '顾客数',
		            min: 0,
		            max: num,
		            interval: num/10,
		            axisLabel: {
		                formatter: '{value}'
		            }
		        },
		        {
		            type: 'value',
		            name: '入店率',
		            min: 0,
		            max: 100,
		            interval: 10,
		            axisLabel: {
		                formatter: '{value} %'
		            }
		        }
		    ],
		    series: [
		        {
		            name:'客流量',
		            type:'bar',
		            data:areadata
		        },
		        {
		            name:'入店量',
		            type:'bar',
		            data:shopdata
		        },
		        {
		            name:'入店率',
		            type:'line',
		            yAxisIndex: 1,
		            data:ratedata
		        }
		    ]
		};
}
</script>




 
</body>
</html>
