package cn.zzrfdsn.bos1.web.action;

import java.io.Serializable;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import cn.zzrfdsn.bos1.model.Decidedzone;
import cn.zzrfdsn.bos1.model.Staff;
import cn.zzrfdsn.bos1.service.IDecidedzoneService;
import cn.zzrfdsn.bos1.service.IStaffService;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;
import cn.zzrfdsn.webService.customerService.Customer;
import cn.zzrfdsn.webService.customerService.ICustomerService;

@Controller
@Scope("prototype")
@RequiresPermissions("viewDecidedzone")
public class DecidedzoneAction extends BaseAction<Decidedzone> {
	private static final long serialVersionUID = 1L;

	@Autowired
	private IDecidedzoneService decidedzoneService;
	@Autowired
	private IStaffService staffService;
	@Autowired
	private ICustomerService customerService;

//	批量删除
	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}
	
	// 关联的分区id
	private String[] subareaId;

	public String[] getSubareaId() {
		return subareaId;
	}

	public void setSubareaId(String[] subareaId) {
		this.subareaId = subareaId;
	}

	//关联的客户id
	private List<Integer> customerIds;
	public List<Integer> getCustomerIds() {
		return customerIds;
	}
	public void setCustomerIds(List<Integer> customerIds) {
		this.customerIds = customerIds;
	}

	/**
	 * 添加定区
	 */
	@RequiresPermissions("addDecidedzone")
	public String add() throws Exception {
		try {
			// 先查询收派员是否存在
			Staff staff = staffService.findById(model.getStaff().getId());
			if (staff == null || !staff.getDeltag().equals('0')) {
				msg = "参数有误！收派员不存在！";
			} else {
				Serializable saveId = decidedzoneService.save(model, subareaId);
				state = SUCCESS_STATE;
				standardJsonObject.put("saveId", saveId);
			}
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}
	
	/**
	 * 修改定区
	 */
	@RequiresPermissions("editDecidedzone")
	public String update() throws Exception {

		try {
			// 先查询收派员是否存在
			Staff staff = staffService.findById(model.getStaff().getId());
			if (staff == null || !staff.getDeltag().equals('0')) {
				msg = "参数有误！收派员不存在！";
			} else {
				decidedzoneService.update(model, subareaId);
				state = SUCCESS_STATE;
			}
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}

	/**
	 * 批量删除
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("deleteDecidedzone")
	public String delete() {

		try {
			String[] idArray = ids.split(",");
			decidedzoneService.batchDelete(idArray);
			standardJsonObject.put("affectRow", idArray.length);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		
		return this.reponseJson(null);
	}
	
	/**
	 * 查询定区与定区列表
	 * @return
	 * @throws Exception
	 */
	public String listData() throws Exception {
		try {
			//封装查询条件
			{
				if(StringUtils.isNotBlank(model.getId())) {
					detachedCriteria.add(Restrictions.ilike("id", "%"+model.getId()+"%"));
				}
				
				if(StringUtils.isNotBlank(model.getName())) {
					detachedCriteria.add(Restrictions.ilike("name", "%"+model.getName()+"%"));
				}
				
				//根据负责人和负责人所属公司查询
				if(model.getStaff()!=null) {
					int count=0;
					DetachedCriteria serechStaffCriteria=DetachedCriteria.forClass(Staff.class);
					if(StringUtils.isNotBlank(model.getStaff().getName())) {
						serechStaffCriteria.add(Restrictions.like("name","%"+model.getStaff().getName()+"%"));
						count++;
					}
					if(StringUtils.isNotBlank(model.getStaff().getStation())) {
						serechStaffCriteria.add(Restrictions.like("station","%"+model.getStaff().getStation()+"%"));
						count++;
					}
					
					if(count>0) {
						List<Staff> staffs = staffService.findStaffListByGiveConditions(serechStaffCriteria);
						if(staffs==null||staffs.size()<1) {
							state=SUCCESS_STATE;
							return this.reponseJson(null,!(format == 1));
						}
						detachedCriteria.add(Restrictions.in("staff",staffs));
					}
				}
			}
			
			decidedzoneService.pageQuery(pageBean);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(pageBean, !(format==1), "currentPage", "showSize", "detachedCriteria", "start", "decidedzones",
				"subareas");
	}

	/**
	 * 查询没有被关联的客户列表
	 * @return
	 * @throws Exception
	 */
	public String noAssociationCustomerData() throws Exception {
		List<Customer> customers = null;
		try {
			customers = customerService.findNoAssociationDecidedzone();
			standardJsonObject.put("data", customers);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
		}
		
		return this.reponseJson(customers);
	}

	/**
	 * 查询已经该定区被关联的客户列表
	 * @return
	 * @throws Exception
	 */
	public String hasAssociationCustomerData() throws Exception {
		List<Customer> customers = null;
		try {
			customers = customerService.findHasAssociationDecidedzone(model.getId());
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
		}
		return this.reponseJson(customers,!(format==1));
	}

	/**
	 * 将客户关联至该定区
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("associatedCustomers")
	public String customerAssociationToDecidedzone() throws Exception {
		try {
			Integer affectRow = customerService.associationDecidedzone(model.getId(), customerIds);
			standardJsonObject.put("affectRow", affectRow);
			state=SUCCESS_STATE;
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}

}
