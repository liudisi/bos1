package cn.zzrfdsn.bos1.web.action;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.zzrfdsn.bos1.model.Permit;
import cn.zzrfdsn.bos1.service.IPermitService;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
public class PermitAction extends BaseAction<Permit> {
	private static final long serialVersionUID = 1L;

	@Autowired
	private IPermitService permitService;
	
	@RequiresPermissions("viewPermit")
	public String listData() throws Exception {
		try {
			// 由于当前model中也有一个属性是page，所以参数会优先被封装到model中
			if(StringUtils.isNotBlank(model.getPage())) {
				pageBean.setCurrentPage(Integer.parseInt(model.getPage()));
			}
			permitService.pageQuery(pageBean);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			e.printStackTrace();
			state = SERVERERROR_STATE;
		}
		return this.reponseJson(pageBean, !(format == 1), "detachedCriteria", "parentPermit", "roles", "subPermits","children");
	}

	@RequiresPermissions("addPermit")
	public String add() {
		try {
			Permit parentPermit = model.getParentPermit();
			if (parentPermit == null||StringUtils.isBlank(parentPermit.getId())) {
				model.setParentPermit(null);
			} else {
				// 查询父级权限是否存在，防止用户直接输入
				parentPermit = permitService.findById(model.getParentPermit().getId());
				if (parentPermit == null) {
					msg = "参数错误！父级权限不存在！";
					return this.reponseJson(null);
				}
			}

			String saveId = permitService.save(model);
			standardJsonObject.put("saveId", saveId);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);

	}

	/**
	 * 返回树形结构数据
	 * @return
	 */
	public String levelsData() {
		List<Permit> permits = null;
		try {
			permits = permitService.findAllForLeaves();
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}

		return this.reponseJson(permits, !(format == 1), "parentPermit", "roles", "subPermits");
	}
	
	
	/**
	 * 加载菜单
	 * @return
	 * @throws Exception
	 */
	public String loadMenu() throws Exception {
		List<Permit> menus=permitService.findAllMenu(this.getCurrentLoginUser(),model.getMenugroup());
		state=SUCCESS_STATE;
		return this.reponseJson(menus,!(format==1),"parentPermit","roles","subPermits","children","text");
	}


}
