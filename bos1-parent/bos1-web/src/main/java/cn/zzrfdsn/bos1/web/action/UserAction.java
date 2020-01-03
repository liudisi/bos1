package cn.zzrfdsn.bos1.web.action;

import java.util.Date;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.subject.Subject;
import org.apache.struts2.ServletActionContext;
import org.hibernate.criterion.Restrictions;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;

import com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException;
import com.opensymphony.xwork2.ActionContext;

import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.service.IUserService;
import cn.zzrfdsn.bos1.utils.MD5Util;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
public class UserAction extends BaseAction<User> {

	private static final Logger logger = Logger.getLogger(UserAction.class);

	private static final long serialVersionUID = 1L;

//	验证码
	private String checkcode;

//	原密码
	private String oldPassword;
//	角色
	private String[] roleIds;

	public String[] getRoleIds() {
		return roleIds;
	}

	public void setRoleIds(String[] roleIds) {
		this.roleIds = roleIds;
	}

//	搜索
	private String search;

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

//	日期范围
	private Date endBirthday;

	public Date getEndBirthday() {
		return endBirthday;
	}

	public void setEndBirthday(Date endBirthday) {
		this.endBirthday = endBirthday;
	}

	@Autowired
	private IUserService userService;

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public void setCheckcode(String checkcode) {
		this.checkcode = checkcode;
	}

	public void setOldPassword(String oldPassword) {
		this.oldPassword = oldPassword;
	}

	/**
	 * 注销
	 * 
	 * @return
	 * @throws Exception
	 */
	public String logout() throws Exception {
		// 销毁session
		ServletActionContext.getRequest().getSession().invalidate();
		return "login";
	}

	/**
	 * 登录
	 * 
	 * @return
	 * @throws Exception
	 */
	public String login() throws Exception {
		HttpSession session = ServletActionContext.getRequest().getSession();
		if (StringUtils.isNotBlank(checkcode) && checkcode.equalsIgnoreCase((String) session.getAttribute("key"))) {
			// User loginUser = userService.login(this.model);

			Subject subject = SecurityUtils.getSubject();// 获取当前用户，现在状态是未认证
			// 用户名密码令牌
			UsernamePasswordToken token = new UsernamePasswordToken(model.getUsername(),
					MD5Util.md5(model.getPassword()));

			// 尝试登录,密码不匹配或用户名不存在则会抛出异常

			try {
				subject.login(token);
				// 获取登录成功的用户放入session
				User user = (User) subject.getPrincipal();
				session.setAttribute("loginUser", user);

				return HOME;
			} catch (Exception e) {
				this.addActionError("用户名或密码错误！");
				e.printStackTrace();
			}

//			if (loginUser != null) {
//				session.setAttribute("loginUser", loginUser);
//				return "home";
//			} else {
//				this.addActionError("用户名或密码错误！");
//			}

		} else {
			this.addActionError("验证码错误！");
		}

		return LOGIN;
	}

	/**
	 * 修改密码
	 * 
	 * @return
	 * @throws Exception
	 */
	public String updatePassword() throws Exception {
		try {
			int affectRow = 0;
			User loginUser = (User) ServletActionContext.getRequest().getSession().getAttribute("loginUser");
			if (loginUser != null && MD5Util.md5(oldPassword).equals(loginUser.getPassword())) {
				try {
					model.setId(loginUser.getId());
					affectRow = userService.updatePassword(model);
					if (affectRow > 0) {
						// 销毁session,在页面调用刷新
						ServletActionContext.getRequest().getSession().invalidate();
						state = SUCCESS_STATE;
					}
				} catch (Exception e) {
					state = SERVERERROR_STATE;
					e.printStackTrace();
				}

			} else {
				state = PARAMERROR_STATE;
				msg = "旧密码不正确";
			}

		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}

		return this.reponseJson(null);
	}

	/**
	 * 登录验证
	 */
	public void validateLogin() {
		if (StringUtils.isBlank(model.getUsername())) {
			this.addFieldError("username", "用户名不能为空！");
		}
		if (StringUtils.isBlank(model.getPassword())) {
			this.addFieldError("username", "密码不能为空！");
		}
	}

	/**
	 * 添加用户
	 */
	@RequiresPermissions("addUser")
	public String add() throws Exception {
		int i = 0;
		if (StringUtils.isBlank(model.getUsername())) {
			i++;
			msg += "用户名不能为空！";
		}
		if (StringUtils.isBlank(model.getPassword())) {
			i++;
			msg += "密码不能为空！";
		}
		if (StringUtils.isBlank(model.getTelephone()) || !model.getTelephone().matches("^1[3456789]\\d{9}$")) {
			i++;
			msg += "手机号格式不正确！";
		}

		if (i <= 0) {
			User user = userService.findUserByUserName(model.getUsername());
			if (user != null) {
				msg = "用户名已经存在！";
			} else {
				user = userService.findUserByTelephone(model.getTelephone());
				if (user == null) {
					String saveId = userService.save(model, roleIds);
					standardJsonObject.put("saveId", saveId);
					state = SUCCESS_STATE;
				} else {
					msg = "手机号已经被绑定！";
				}
			}
		}
		return this.reponseJson(null);
	}

	public String checkUserName() throws Exception {
		if (StringUtils.isNotBlank(model.getUsername())) {
			User user = userService.findUserByUserName(model.getUsername());
			standardJsonObject.put("exist", user != null);
			state = SUCCESS_STATE;
		}

		return this.reponseJson(null);
	}

	public String checkTelephone() throws Exception {
		if (StringUtils.isNotBlank(model.getTelephone()) && model.getTelephone().matches("^1[3456789]\\d{9}$")) {
			User user = userService.findUserByTelephone(model.getTelephone());
			standardJsonObject.put("exist", user != null);
			state = SUCCESS_STATE;
		}

		return this.reponseJson(null);
	}

	@RequiresPermissions("viewUsers")
	public String listData() throws Exception {
		if (StringUtils.isNotBlank(search)) {
			if (model.getBirthday() != null && endBirthday != null) {
				detachedCriteria.add(Restrictions.between("birthday", model.getBirthday(), endBirthday));
			} else if (model.getBirthday() != null) {
				detachedCriteria.add(Restrictions.ge("birthday", model.getBirthday()));
			} else if (endBirthday != null) {
				detachedCriteria.add(Restrictions.le("birthday", endBirthday));
			}

			if (StringUtils.isNotBlank(model.getUsername())) {
				detachedCriteria.add(Restrictions.like("username", "%" + model.getUsername() + "%"));
			}
			if (StringUtils.isNotBlank(model.getGender())) {
				detachedCriteria.add(Restrictions.eq("gender", model.getGender()));
			}
		}
		userService.pageQuery(pageBean);
		state = SUCCESS_STATE;
		return this.reponseJson(pageBean, !(format == 1), "detachedCriteria", "roles", "password", "telephone");
	}

	/**
	 * 更新用户信息
	 */

	@RequiresPermissions("userEdit")
	public String update() {

		try {
			userService.update(model, roleIds);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}

	/**
	 * 删除用户
	 */
	@RequiresPermissions("userDelete")
	public String delete() throws Exception {

		try {
			String[] ids = model.getId().split(",");
			int affectRow = userService.delete(ids, this.getCurrentLoginUser());
			state = SUCCESS_STATE;
			standardJsonObject.put("affectRow", affectRow);
		} catch (DataIntegrityViolationException e) {
			msg = "该用户数据很重要！不可删除！";
			e.printStackTrace();
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}

//	获取用户基本信息
	public String info() throws Exception {
		User user = userService.findUserById(model.getId());
		ActionContext.getContext().put("user", user);
		return "info";
	}
	
}
