package cn.zzrfdsn.bos1.web.action;

import java.io.File;
import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.struts2.ServletActionContext;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.hutool.core.date.DateUnit;
import cn.hutool.core.date.DateUtil;
import cn.zzrfdsn.bos1.model.Workordermanage;
import cn.zzrfdsn.bos1.service.IWorkordermanageService;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
public class WorkordermanageAction extends BaseAction<Workordermanage> {

	@Autowired
	private IWorkordermanageService workordermanageService;

	private static final long serialVersionUID = 1L;

	// 批量导入
	private File workOrders;

	public void setWorkOrders(File workOrders) {
		this.workOrders = workOrders;
	}

	/**
	 * 添加和更新快递单
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("addOrUpdateWorkordermanage")
	public String addOrUpdate() throws Exception {

		try {
			if (StringUtils.isBlank(model.getId())) {
				workordermanageService.save(model);
			} else {
				workordermanageService.update(model);
			}
			state = SUCCESS_STATE;
			standardJsonObject.put("id", model.getId());
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}

		return this.reponseJson(null);
	}

	/**
	 * 列表数据
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("viewWorkordermanage")
	public String listData() throws Exception {
		try {

			{
				if (StringUtils.isNotBlank(model.getId())) {
					detachedCriteria.add(Restrictions.eq("id", model.getId()));
				}

				if (StringUtils.isNotBlank(model.getSenderphone())) {
					detachedCriteria.add(Restrictions.eq("senderphone", model.getSenderphone()));
				}

				if (StringUtils.isNotBlank(model.getReceiverphone())) {
					detachedCriteria.add(Restrictions.eq("receiverphone", model.getReceiverphone()));
				}
			}

			workordermanageService.pageQuery(pageBean);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			e.printStackTrace();
			state = SERVERERROR_STATE;
		}
		return this.reponseJson(pageBean, !(format == 1), "currentPage", "showSize", "detachedCriteria", "start");
	}

	/**
	 * 批量导入
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("batchImportWorkordermanage")
	public String batchImport() throws Exception {

		List<Workordermanage> workordermanages = new ArrayList<Workordermanage>();
		// 包装一个excel对象
		HSSFWorkbook excel = new HSSFWorkbook(new FileInputStream(workOrders));
		// 读取文件中第一个sheet标签页
		HSSFSheet sheet = excel.getSheetAt(0);
		// 遍历标签页中的所有行
		for (Row row : sheet) {
			// 标题行和空行跳过
			int cells = row.getPhysicalNumberOfCells();
			if (cells<2||row.getRowNum() == 0) {
				continue;
			}

			String product = row.getCell(0).getStringCellValue();
			Date deadline = row.getCell(1).getDateCellValue();
			Date todayDate = new Date();
			//计算最后期限与今天相差的天数
			String prodtimelimit = DateUtil.between(todayDate, deadline, DateUnit.DAY) + "天";
			String prodtype = row.getCell(2).getStringCellValue();
			String sendername = row.getCell(3).getStringCellValue();
			DecimalFormat df = new DecimalFormat("#");
			String senderphone = df.format(row.getCell(4).getNumericCellValue());
			String senderaddr = row.getCell(5).getStringCellValue();
			String receivername = row.getCell(6).getStringCellValue();
			String receiverphone = df.format(row.getCell(7).getNumericCellValue());
			String receiveraddr = row.getCell(8).getStringCellValue();
			int feeitemnum = (int) row.getCell(9).getNumericCellValue();
			String arrivecity = receiveraddr.substring(0, receiveraddr.indexOf("市") + 1);
			Workordermanage workordermanage = new Workordermanage(null, arrivecity, product, null, null, null,
					prodtimelimit, prodtype, sendername, senderphone, senderaddr, receivername, receiverphone,
					receiveraddr, feeitemnum, null, null, null, todayDate);

			workordermanages.add(workordermanage);
		}

		workordermanageService.batchSaveOrUpdate(workordermanages);

		excel.close();

		ServletActionContext.getResponse().getWriter().write("200");
		return null;
	}
}
