
----------CRM项目----------

整体框架：SSM

版本控制：Maven

测试使用服务器：Tomcat

后端运用：
  框架：持久层：mybatis；业务层：Java；视图层：springMVC
  数据库：MySQL
  备注：连接池使用的是阿里Druid
前端运用：
  框架：bootstrap，jQuery
   静态页：HTML，JavaScript，css；动态页：JSP
备注：数据库转Java使用了mybatis逆向工程
crm因大部分是在内网中使用，很少存在高并发情况，所以工程未使用高并发多线程，但可以通过Redis和Java线程转化高并发工程
备注2：项目完成比例80%，完成了核心的数据字典、用户模块、主体业务内容
