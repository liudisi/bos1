package cn.zzrfdsn.bos1.web.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.zzrfdsn.bos1.model.Decidedzone;
import cn.zzrfdsn.bos1.model.Region;
import cn.zzrfdsn.bos1.model.Subarea;
import cn.zzrfdsn.bos1.service.IRegionService;
import cn.zzrfdsn.bos1.service.ISubareaService;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
@RequiresPermissions("viewSubarea")
public class SubareaAction extends BaseAction<Subarea> {
	private static final long serialVersionUID = 1L;

	@Autowired
	private ISubareaService subareaService;

	@Autowired
	private IRegionService regionService;

//	批量删除
	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}
	
//	批量导入文件上传
	private File subareas;
	
	public void setSubareas(File subareas) {
		this.subareas = subareas;
	}

	/**
	 * 添加分区
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("addSubarea")
	public String add() {

		try {
			if (model.getRegion() != null) {

				Region region = regionService.findById(model.getRegion().getId());

				if (region != null) {
					Serializable saveId = subareaService.save(model);
					standardJsonObject.put("saveId", saveId);
					state = SUCCESS_STATE;
				} else {
					msg = "区域参数有误！区域不存在！";
				}
			}
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}

		return this.reponseJson(null);
	}

	/**
	 * 更新分区
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("editSubarea")
	public String update() {

		try {
			if (model.getRegion() != null) {

				Region region = regionService.findById(model.getRegion().getId());

				if (region != null) {
					subareaService.update(model);
					state = SUCCESS_STATE;
				} else {
					msg = "区域参数有误！区域不存在！";
				}
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
	@RequiresPermissions("deleteSubarea")
	public String delete() {

		try {
			String[] idArray = ids.split(",");

			subareaService.batchDelete(idArray);
			standardJsonObject.put("affectRow", idArray.length);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		
		return this.reponseJson(null);
	}

	/**
	 * 数据列表（分页）
	 * 
	 * @return
	 */
	public String listData() {
		try {
			// 条件查询
			String addresskey = model.getAddresskey();
			if (StringUtils.isNotBlank(addresskey)) {
				detachedCriteria.add(Restrictions.like("addresskey", "%" + addresskey + "%"));
			}

			Region region = model.getRegion();
			if (region != null) {
				// 涉及连表查询需要添加别名 属性名，别名
				detachedCriteria.createAlias("region", "rg");
				String province = region.getProvince();
				String city = region.getCity();
				String district = region.getDistrict();
				if (StringUtils.isNotBlank(province)) {
					detachedCriteria.add(Restrictions.like("rg.province", "%" + province + "%"));
				}
				if (StringUtils.isNotBlank(city)) {
					detachedCriteria.add(Restrictions.like("rg.city", "%" + city + "%"));
				}
				if (StringUtils.isNotBlank(district)) {
					detachedCriteria.add(Restrictions.like("rg.district", "%" + district + "%"));
				}
			}

			// 需要将hibernate的懒加载关闭，否则json序列化失败
			subareaService.pageQuery(pageBean);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return reponseJson(pageBean, !(format == 1), "decidedzone", "subareas", "currentPage", "detachedCriteria",
				"showSize", "start");
	}

	/**
	 * 导出excel
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("exportSubarea")
	public String export() throws Exception {
		List<Subarea> subareas = subareaService.findAll();
		HSSFWorkbook excel = new HSSFWorkbook();
		// 创建sheet页
		HSSFSheet sheet = excel.createSheet("分区数据");
		// 创建标题行
		HSSFRow headRow = sheet.createRow(0);
		// 创建标题单元格
		headRow.createCell(0).setCellValue("分区编号");
		headRow.createCell(1).setCellValue("省");
		headRow.createCell(2).setCellValue("市");
		headRow.createCell(3).setCellValue("区");
		headRow.createCell(4).setCellValue("关键字");
		headRow.createCell(5).setCellValue("起始号");
		headRow.createCell(6).setCellValue("终止号");
		headRow.createCell(7).setCellValue("单双号");
		headRow.createCell(8).setCellValue("位置");
		// 循环创建行
		for (Subarea subarea : subareas) {
			// 行号为最大行号+1
			HSSFRow row = sheet.createRow(sheet.getLastRowNum() + 1);
			row.createCell(0).setCellValue(subarea.getId());
			row.createCell(1).setCellValue(subarea.getRegion().getProvince());
			row.createCell(2).setCellValue(subarea.getRegion().getCity());
			row.createCell(3).setCellValue(subarea.getRegion().getDistrict());
			row.createCell(4).setCellValue(subarea.getAddresskey());
			row.createCell(5).setCellValue(subarea.getStartnum());
			row.createCell(6).setCellValue(subarea.getEndnum());
			String single = subarea.getSingle() == null ? "" : subarea.getSingle() + "";
			row.createCell(7).setCellValue(single);
			row.createCell(8).setCellValue(subarea.getPosition());
		}

		// 使用输出流进行文件下载写给客户端
		String fileName = "subareaData.xls";
		ServletOutputStream out = this.getFileDownloadOutPutStream(fileName);
		// 写出到客户端
		excel.write(out);
		excel.close();
		return null;
	}
	
	/**
	 * execel批量导入
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("batchImportSubarea")
	public String batchImport() throws Exception {
		try {
			HSSFWorkbook excel=new HSSFWorkbook(new FileInputStream(subareas));
			HSSFSheet sheet0 = excel.getSheetAt(0);
			List<Subarea> subareas=new ArrayList<Subarea>();
			for (Row row : sheet0) {
				if(row.getRowNum()==0) {
					continue;
				}
				String id=row.getCell(0).getStringCellValue();
				String regionId = row.getCell(1).getStringCellValue();
				String addresskey=row.getCell(2).getStringCellValue();
				String startnum=row.getCell(3).getStringCellValue();
				String endnum=row.getCell(4).getStringCellValue();
				Character single=row.getCell(5).getStringCellValue().toCharArray()[0];
				String position=row.getCell(6).getStringCellValue();
				
				Region region=new Region();
				region.setId(regionId);
				
				Subarea subarea=new Subarea(id, null, region, addresskey, startnum, endnum, single, position);
				subareas.add(subarea);
			}
			subareaService.batchSaveOrUpdate(subareas);
			state=SUCCESS_STATE;
			excel.close();
		} catch (Exception e) {
			state=SERVERERROR_STATE;
			msg="出错了，请检查你上传的文件 格式与模板是否一致！分区编号不能重复，所有字段不能为空，区域编号需存在，不要留有空行";
			e.printStackTrace();
		}
		return reponseJson(null);
	}

	/**
	 * 分布数据
	 */
	public String distributeData() throws Exception {
		List<Object> data = null;
		try {
			data = subareaService.findAllGroupByProvince();
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		;
		return this.reponseJson(data);
	}

	/**
	 * 查询没有关联定区的分区
	 * 
	 * @return
	 * @throws Exception
	 */
	public String noAssociationList() throws Exception {
		detachedCriteria.add(Restrictions.isNull("decidedzone"));
		List<Subarea> subareas = subareaService.findNoAssociationList(detachedCriteria);
		return this.reponseJson(subareas, !(format == 1), "decidedzone", "region");
	}

	/**
	 * 查询已经关联指定定区的分区
	 * @return
	 * @throws Exception
	 */
	public String associationDecidedzoneList() throws Exception {
		List<Subarea> subareas = subareaService.findListByDecidedzoneId(model.getDecidedzone().getId());
		return this.reponseJson(subareas, !(format == 1), "decidedzone", "subareas");
	}

	/**
	 * 取消关联与定区的关联
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("cancelAssociationSubarea")
	public String cancelAssociationDecidezone() throws Exception {
		subareaService.cancelAssociationDecidezone(model.getId());
		state=SUCCESS_STATE;
		return this.reponseJson(null);
	}
}
