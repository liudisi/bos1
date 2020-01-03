# bos1

该项目当初是放在码云上，更新代码时没有及时push，又不小心给本地源码删除了，就没有转移到github上，不过好在这几天发现自己的服务器上还存放着war包，就将war包下载下来反编译回来一部分结合着码云上的旧代码做了下整合。



> 本系统采用ssh框架开发（struts2.3.24、spring4.2、hibernate5.0.7），web层使用struts2、持久层采用hibernate5，spring管理web层 的action、业务层的service、持久层的dao。前台使用jQuery EasyUI进行页面展示。



## spring的作用

​	spring管理web层 的action、业务层的service、持久层的dao，对struts的action采用多例的方式管理，对service和dao采用单例方式。

​	本系统采用声明式事务控制方式对service层进行事务控制，spring和hibernate整合后， spring在service方法开发执行前创建session，开启事务，方法结束提交事务，关闭session。

​	spring和shiro进行整合开发，spring管理shiro框架的securityManager、realm等bean，另外spring通过cglib方式生成action的代理对象，实现权限控制。

​	spring和CXF框架整合开发远程调用接口。



## 项目中如何进行事务管理的？

这个项目的事务管理是通过spring的声明式事务进行管理的，具体做法是使用spring提供的事务注解，为Service创建代理对象，由代理对象进行事务控制。



## 这个系统持久层如何实现的？ 

本系统使用hibernate5.0.7 版本。

本系统使用hibernate的QBC和HQL两种方式开发。使用hibernate可以大大简化持久层开发。

本系统对Dao层进行封装，采用泛型封装BaseDao，在spring定义bean的配置中通过BaseDao的构造方法动态获得操作的实体类型，这样做的好处是只需要在系统定义一个BaseDao即可，根据模型的不同在spring的配置文件定义不同的Dao。



## hibernate延迟加载问题

在开发中遇到延迟加载问题了，通过spring的OpenSessionInViewFilter过滤器解决这个问题。但这个还不够，比如在页面中使用easyUI的datagrid展示数据，这时在服务端查询到数据后，需要转为json返回给datagrid，这时如果查询到的对象内部引用了关联对象，而这个关联对象是延迟加载的，就无法转为json，这时就需要使用立即加载策略。



## 这个系统UI使用什么框架？

- 系统UI使用Jquery easy UI，及jquery库。
- 系统框架布局使用layout，系统标签窗口采用tabs，系统菜单使用方accordion，数据列表采用datagrid，
- 弹出窗口 window
- 消息提示：messager
- 菜单：menubutton
- 下拉框：combobox



## 这个系统的认证和授权是怎么实现的

本系统使用了Apache Shiro框架完成认证和授权。shiro框架中的对象创建由spring负责创建。

shiro框架共提供了4中权限控制方式，本系统中使用到前3种方式：

1. URL拦截权限控制，通过shiro框架提供的过滤器实现

   ```xml
   	<!-- 配置shiroFilter -->
   	<bean name="shiroFilter"
   		class="org.apache.shiro.spring.web.ShiroFilterFactoryBean">
   		<!-- 权限管理器 -->
   		<property name="securityManager" ref="securityManager" />
   		<!-- 登录页面 -->
   		<property name="loginUrl" value="/login.jsp" />
   		<!-- 验证通过跳转页面 -->
   		<property name="successUrl" value="/index.jsp" />
   		<!-- 权限验证失败跳转页面 -->
   		<property name="unauthorizedUrl"
   			value="/authenticationFailed.jsp" />
   		<!-- 指定url级别拦截规则 -->
   		<property name="filterChainDefinitions">
   			<value>
   				/css/**=anon
   				/images/**=anon
   				/js/**=anon
   				/json/**=anon
   				/login.jsp*=anon
   				/validatecode.jsp*=anon
   				/user/login=anon
   				/**=authc
   			</value>
   		</property>
   	</bean>
   	<!-- 开启shiro注解 -->
   	<bean name="defaultAdvisorAutoProxyCreator"
   		class="org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator">
   		<!-- 指定使用cglib代理，默认jdk代理 -->
   		<property name="proxyTargetClass" value="true" />
   	</bean>
   	<!-- 配置shiro框架提供的切面类，用于创建代理对象 -->
   	<bean class="org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor" />
   ```

2. 方法注解权限控制，通过为Action创建代理对象实现

   ```java
   /**
    * 批量删除
    * 执行这个方法需要具有deleteStaff的权限，没有权限框架的代理对象会抛出异常，这个方法也就执行不到
    * @return
    * @throws Exception
    */
   @RequiresPermissions("deleteStaff")
   public String delete() {
   
   	try {
   		String[] idArray = ids.split(",");
   
   		int affectRow = staffService.batchDelete(idArray);
   
   		standardJsonObject.put("affectRow", affectRow);
   		state = SUCCESS_STATE;
   	} catch (Exception e) {
   		state = SERVERERROR_STATE;
   		e.printStackTrace();
   	}
   	return this.reponseJson(null);
   }
   ```

3. 页面标签权限控制，通过shiro框架提供的标签实现

   ```jsp
   <shiro:hasPermission name="staff.delete">
       {
       	id: 'button-delete',
       	text: '删除',
       	//......
       },
   </shiro:haspermissio>
   ```

4. 代码级别权限控制，通过在程序中调用shiro的API完成权限控制

   ```java
   public String edit() throws Exception {
   
   	Subject subject = SecurityUtils.getSubject();
   	subject.checkPermission("editStaff");
   
   	// 先从数据库中查询出数据
   	Staff staff = staffService.findById(model.getId());
       
       //......
   }
   ```



## 调用接口

在业务受理、自动分单时，bos系统需要调用物流公司的crm系统获取客户信息。

采用CXF框架实现远程调用，由于接口同步的数据量不大，hessian采用框架定义的二进行协议传输数据，速度很快，本系统采用CXF。

在开发时将服务端的接口拷贝至本系统，在 spring的配置文件中配置代理接口，在本系统的service中直接注入调用，非常方便。

