package cn.zzrfdsn.bos1.web.action;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.subject.Subject;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.zzrfdsn.bos1.model.Staff;
import cn.zzrfdsn.bos1.service.IStaffService;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
public class StaffAction extends BaseAction<Staff> {

	private static final long serialVersionUID = 1L;

	@Autowired
	private IStaffService staffService;

	public void setStaffService(IStaffService staffService) {
		this.staffService = staffService;
	}

//	批量删除
	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

//	判断是否是搜索不为空这是
	private Integer search;

	public Integer getSearch() {
		return search;
	}

	public void setSearch(Integer search) {
		this.search = search;
	}

	/**
	 * 添加收派员
	 * 
	 * @return
	 * @throws Exception
	 */
	
	
	@RequiresPermissions("addStaff")
	public String add() throws Exception {
		staffService.save(model);
		return LIST;
	}

	/**
	 * 列表数据
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("viewStaff")
	public String listData() throws Exception {
		try {
			if (search != null) {
				if (StringUtils.isNotBlank(model.getName())) {
					detachedCriteria.add(Restrictions.ilike("name", "%" + model.getName() + "%"));
				}
				if (StringUtils.isNotBlank(model.getTelephone())) {
					detachedCriteria.add(Restrictions.ilike("telephone", "%" + model.getTelephone() + "%"));
				}
				if (StringUtils.isNotBlank(model.getStation())) {
					detachedCriteria.add(Restrictions.ilike("station", "%" + model.getStation() + "%"));
				}
				if (StringUtils.isNotBlank(model.getStandard())) {
					detachedCriteria.add(Restrictions.ilike("standard", "%" + model.getStandard() + "%"));
				}
				if (model.getDeltag() != null) {
					detachedCriteria.add(Restrictions.eq("deltag", model.getDeltag()));
				}
				if (model.getHaspda() != null) {
					detachedCriteria.add(Restrictions.eq("haspda", model.getHaspda()));
				}
			}

			staffService.pageQuery(pageBean);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		// 查询完数据已经被封装到pagebean,接下来转为json
		return this.reponseJson(pageBean, !(format == 1), "currentPage", "showSize", "detachedCriteria", "start",
				"decidedzones");
	}

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

	/**
	 * 批量还原
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("restoreStaff") //
	public String restore() {

		try {
			String[] idArray = ids.split(",");

			int affectRow = staffService.batchRestore(idArray);
			standardJsonObject.put("affectRow", affectRow);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}

	/**
	 * 编辑
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("editStaff")
	public String edit() throws Exception {

		Subject subject = SecurityUtils.getSubject();
		subject.checkPermission("editStaff");

		// 先从数据库中查询出数据
		Staff staff = staffService.findById(model.getId());
		staff.setName(model.getName());
		staff.setTelephone(model.getTelephone());
		staff.setStation(model.getStation());
		staff.setHaspda(model.getHaspda());
		staff.setStandard(model.getStandard());
		staffService.update(staff);

		return LIST;
	}

	/**
	 * 获取没有被删除的取派员列表
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("viewStaff")
	public String availableStaffList() throws Exception {
		detachedCriteria.add(Restrictions.eq("deltag", '0'));
		List<Staff> staffs = staffService.findStaffListByGiveConditions(detachedCriteria);
		return this.reponseJson(staffs, !(format == 1), "decidedzones");
	}

}
