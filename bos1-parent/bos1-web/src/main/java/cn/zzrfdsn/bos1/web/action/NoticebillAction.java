package cn.zzrfdsn.bos1.web.action;

import java.io.Serializable;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.zzrfdsn.bos1.model.Noticebill;
import cn.zzrfdsn.bos1.service.INoticebillService;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;
import cn.zzrfdsn.webService.customerService.Customer;
import cn.zzrfdsn.webService.customerService.ICustomerService;

@Controller
@Scope("prototype")
@RequiresPermissions("viewNoticeBill")
public class NoticebillAction extends BaseAction<Noticebill> {
	private static final long serialVersionUID = 1L;
	@Autowired
	private INoticebillService noticebillService;
	@Autowired
	private ICustomerService customerService;
	
	//定区Id
	private String decidedzoneId;
	public String getDecidedzoneId() {
		return decidedzoneId;
	}
	public void setDecidedzoneId(String decidedzoneId) {
		this.decidedzoneId = decidedzoneId;
	}

	/**
	 * 添加业务通知单
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("addNoticeBill")
	public String add() throws Exception {
		try {
			Serializable saveId = noticebillService.save(model,decidedzoneId,getCurrentLoginUser());
			standardJsonObject.put("saveId", saveId);
			standardJsonObject.put("type", model.getOrdertype());
			state=SUCCESS_STATE;
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}
	
	/**
	 * 根据手机号获取客户信息
	 */
	@RequiresPermissions("addNoticeBill")
	public String customerInfoByTelephone() throws Exception {
		Customer customer=null;
		if(model.getTelephone()!=null) {
			try {
				customer = customerService.findCustomerByTelephone(model.getTelephone());
				state=SUCCESS_STATE;
			} catch (Exception e) {
				state=SERVERERROR_STATE;
				e.printStackTrace();
			}
		}
		return this.reponseJson(customer,!(format==1));
	}

	/**
	 * 没有自动分单的列表
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("viewNoticeBill")
	public String needmanMadeList() throws Exception {
		detachedCriteria.add(Restrictions.eq("ordertype", Noticebill.ORDERTYPE_NONAUTO)).add(Restrictions.isNull("staff"));
		noticebillService.pageQuery(pageBean);
		state=SUCCESS_STATE;
		return this.reponseJson(pageBean, !(format == 1), "currentPage", "showSize", "detachedCriteria", "start",
				"workbills","staff");
	}

	/**
	 * 人工分单
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("createWorkBill")
	public String createWorkBill() throws Exception {
		try {
			String[] idArray=model.getId().split(",");
			noticebillService.createWorkBill(idArray,model.getStaff().getId());
			state=SUCCESS_STATE;
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}

}
