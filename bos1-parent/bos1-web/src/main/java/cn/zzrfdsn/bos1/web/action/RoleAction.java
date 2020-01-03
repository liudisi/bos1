package cn.zzrfdsn.bos1.web.action;

import java.util.List;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.zzrfdsn.bos1.model.Role;
import cn.zzrfdsn.bos1.service.IRoleService;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
public class RoleAction extends BaseAction<Role> {
	private static final long serialVersionUID = 1L;

	private String permitIds;
	public String getPermitIds() {
		return permitIds;
	}
	public void setPermitIds(String permitIds) {
		this.permitIds = permitIds;
	}
	
	@Autowired
	private IRoleService roleService;
	
	@RequiresPermissions("addOrUpdateRole")
	public String addOrUpdate() throws Exception {
		try {
			String saveId=roleService.saveOrUpdate(model,permitIds);
			if(saveId!=null) {
				standardJsonObject.put("saveId", saveId);
			}
			state=SUCCESS_STATE;
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}
	
	@RequiresPermissions("viewRoles")
	public String listData() throws Exception {
		try {
			roleService.pageQuery(pageBean);
			state=SUCCESS_STATE;
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			e.printStackTrace();
		}
		
		return this.reponseJson(pageBean,!(format==1),"detachedCriteria","permits","users");
	}
	
	@RequiresPermissions("viewRoles")
	public String allData() throws Exception {
		List<Role> roles=roleService.findAll();
		state=SUCCESS_STATE;
		return reponseJson(roles, !(format==1),"permits","users","ownPermits");
	}

	@RequiresPermissions("deleteRole")
	public String delete() throws Exception {
		try {
			roleService.delete(model);
			state=SUCCESS_STATE;
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			e.printStackTrace();
		}
		return reponseJson(null);
	}
	
	@RequiresPermissions("viewRoles")
	public String info() throws Exception {
		Role role=null;
		try {
			role= roleService.findById(model.getId());
			if (role!=null) {
				state=SUCCESS_STATE;
			}
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(role, "users","parentPermit","subPermits","roles");
	}
}
