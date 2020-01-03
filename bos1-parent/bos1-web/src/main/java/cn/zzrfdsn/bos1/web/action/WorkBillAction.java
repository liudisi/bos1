package cn.zzrfdsn.bos1.web.action;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.zzrfdsn.bos1.model.Noticebill;
import cn.zzrfdsn.bos1.model.Staff;
import cn.zzrfdsn.bos1.model.Workbill;
import cn.zzrfdsn.bos1.service.INoticebillService;
import cn.zzrfdsn.bos1.service.IStaffService;
import cn.zzrfdsn.bos1.service.IWorkbillService;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
public class WorkBillAction extends BaseAction<Workbill> {
	private static final long serialVersionUID = 1L;

	@Autowired
	private IWorkbillService workbillService;

	@Autowired
	private INoticebillService noticebillService;

	@Autowired
	private IStaffService staffService;
	
//	批量追单
	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	// 表示按条件查询
	private String search;

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	/**
	 * 查询工单列表
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("viewWorkBill")
	public String listData() throws Exception {

		// 条件查询
		if (StringUtils.isNotBlank(search)) {
			if (model.getNoticebill() != null) {
				Noticebill noticebill = model.getNoticebill();
				DetachedCriteria searchNoticebill = DetachedCriteria.forClass(Noticebill.class);
				int count = 0;
				// 客户电话
				if (StringUtils.isNotBlank(noticebill.getTelephone())) {
					searchNoticebill.add(Restrictions.like("telephone", "%"+noticebill.getTelephone()+"%"));
					count++;
				}
				// 是否自动分单
				if (noticebill.getOrdertype() != null && !"-1".equals(noticebill.getOrdertype())) {
					searchNoticebill.add(Restrictions.eq("ordertype", noticebill.getOrdertype()));
					count++;
				}

				if (count > 0) {
					List<Noticebill> noticebills = noticebillService
							.findNoticebillListByGiveConditions(searchNoticebill);
					if(noticebills==null||noticebills.size()<1) {
						state=SUCCESS_STATE;
						return this.reponseJson(null,!(format == 1));
					}
					detachedCriteria.add(Restrictions.in("noticebill", noticebills));
				}
			}
			// 工单类型
			if (model.getType() != null && !"-1".equals(model.getType())) {
				detachedCriteria.add(Restrictions.eq("type", model.getType()));
			}
			// 取件状态
			if (model.getPickstate() != null && !"-1".equals(model.getPickstate())) {
				detachedCriteria.add(Restrictions.eq("pickstate", model.getPickstate()));
			}
			// 工单生成日期
			if (model.getBuildtime() != null) {
				detachedCriteria.add(Restrictions.gt("buildtime", model.getBuildtime()));
			}
			// 追单次数
			if (model.getAttachbilltimes() != null) {
				detachedCriteria.add(Restrictions.gt("attachbilltimes", model.getAttachbilltimes()));
			}
			// 取派员
			if (model.getStaff() != null && StringUtils.isNotBlank(model.getStaff().getName())) {
				DetachedCriteria searchSatff = DetachedCriteria.forClass(Staff.class);
				searchSatff.add(Restrictions.eq("name", model.getStaff().getName()));
				List<Staff> staffs = staffService.findStaffListByGiveConditions(searchSatff);
				if(staffs==null||staffs.size()<1) {
					state=SUCCESS_STATE;
					return this.reponseJson(null,!(format == 1));
				}
				detachedCriteria.add(Restrictions.in("staff", staffs));
				
			}
		}
		workbillService.pageQuery(pageBean);
		state=SUCCESS_STATE;
		return this.reponseJson(pageBean, !(format == 1), "currentPage", "showSize", "detachedCriteria", "start",
				"noticebill.staff", "decidedzones", "workbills");
	}


	/**
	 * 	催单
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("attachbill")
	public String attachbill() throws Exception {
		String[] idArray = ids.split(",");
		workbillService.attachbill(idArray);
		standardJsonObject.put("affectRow", idArray.length);
		state=SUCCESS_STATE;
		return this.reponseJson(null);
	}
	
	/**
	 * 销单
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("cancelbill")
	public String cancelbill() throws Exception {
		String[] idArray = ids.split(",");
		workbillService.cancelbill(idArray);
		standardJsonObject.put("affectRow", idArray.length);
		state=SUCCESS_STATE;
		return this.reponseJson(null);
	}

}
