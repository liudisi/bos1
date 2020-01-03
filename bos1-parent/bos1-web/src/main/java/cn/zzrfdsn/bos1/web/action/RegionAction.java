package cn.zzrfdsn.bos1.web.action;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.struts2.ServletActionContext;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.hutool.core.util.IdUtil;
import cn.zzrfdsn.bos1.model.Region;
import cn.zzrfdsn.bos1.service.IRegionService;
import cn.zzrfdsn.bos1.utils.PinYin4jUtils;
import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
public class RegionAction extends BaseAction<Region> {

	private final Logger logger = Logger.getLogger(getClass());

	/**
	 * 查询关键字
	 */
	private String q;

	public String getQ() {
		return q;
	}

	public void setQ(String q) {
		this.q = q;
	}

//	批量删除
	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	@Autowired
	private IRegionService regionService;
	private File regions;

	public void setRegions(File regions) {
		this.regions = regions;
	}

	private static final long serialVersionUID = 1L;

	/**
	 * 批量导入
	 * 
	 * @return
	 * @throws Exception
	 */
	
	@RequiresPermissions("batchImportRegion")
	public String batchImport() throws Exception {

		List<Region> regionList = new ArrayList<Region>();
		// 包装一个excel对象
		HSSFWorkbook excel = new HSSFWorkbook(new FileInputStream(regions));
		// 读取文件中第一个sheet标签页
		HSSFSheet sheet = excel.getSheetAt(0);
		// 遍历标签页中的所有行
		for (Row row : sheet) {
			// 标题行和空行跳过
			int cells = row.getPhysicalNumberOfCells();
			if (cells < 2 || row.getRowNum() == 0) {
				continue;
			}
			// 没有填写编号则生成uuid
			String id = row.getCell(0) == null || StringUtils.isBlank(row.getCell(0).getStringCellValue())
					? IdUtil.simpleUUID()
					: row.getCell(0).getStringCellValue();
			String province = row.getCell(1).getStringCellValue();
			String city = row.getCell(2).getStringCellValue();
			String district = row.getCell(3).getStringCellValue();
			String postcode = row.getCell(4).getStringCellValue();

			// 使用Pinyin4j生成简码 河南省信阳市固始县-->HNXYGS
			String provinceShort = province.substring(0, province.length() - 1);
			String cityShort = city.substring(0, city.length() - 1);
			String districtShort = district.substring(0, district.length() - 1);
			String shortcode = provinceShort + cityShort + districtShort;
			shortcode = StringUtils.join(PinYin4jUtils.getHeadByString(shortcode));

			// 生成城市编码 信阳市-->xinyang
			String citycode = StringUtils.join(PinYin4jUtils.stringToPinyin(cityShort));

			logger.debug("id：" + id + " 省：" + province + " 市：" + city + " 区：" + district + " 邮编：" + postcode + " 简码："
					+ shortcode + " 城市编码：" + citycode);

			Region region = new Region(id, province, city, district, postcode, shortcode, citycode, null);
			regionList.add(region);
		}

		regionService.batchSaveOrUpdate(regionList);
		excel.close();
		ServletActionContext.getResponse().getWriter().write("200");
		return null;
	}

	/**
	 * 列表数据(分页)
	 * 
	 * @return
	 * @throws Exception
	 */
	
	@RequiresPermissions("viewRegion")
	public String listData() {
		try {
			regionService.pageQuery(pageBean);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(pageBean, !(format == 1), "subareas", "currentPage", "showSize", "detachedCriteria",
				"start");
	}

	/**
	 * 根据条件查询
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("viewRegion")
	public String search() throws Exception {
		List<Region> regionlList = null;
		try {
			if (StringUtils.isNotBlank(q)) {
				detachedCriteria.add(Restrictions.or(Restrictions.like("province", "%" + q + "%"),
						Restrictions.like("district", "%" + q + "%"), Restrictions.like("postcode", "%" + q + "%"),
						Restrictions.like("shortcode", "%" + q + "%"), Restrictions.like("citycode", "%" + q + "%"),
						Restrictions.like("city", "%" + q + "%")));
			}

			regionlList = regionService.findAllBySearch(detachedCriteria);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}

		return this.reponseJson(regionlList, !(format == 1), "subareas");
	}

	/**
	 * 添加或者更新区域
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequiresPermissions("editAndAddRegion")
	public String addOrUpdate() throws Exception {
		try {
			if (StringUtils.isBlank(model.getId())) {
				model.setId(IdUtil.simpleUUID());
			}
			String provinceShort = model.getProvince().substring(0, model.getProvince().length() - 1);
			String cityShort = model.getCity().substring(0, model.getCity().length() - 1);
			String districtShort = model.getDistrict().substring(0, model.getDistrict().length() - 1);
			String shortcode = provinceShort + cityShort + districtShort;
			shortcode = StringUtils.join(PinYin4jUtils.getHeadByString(shortcode));
			model.setShortcode(shortcode);

			String citycode = StringUtils.join(PinYin4jUtils.stringToPinyin(cityShort));
			model.setCitycode(citycode);

			List<Region> tempRegions = new ArrayList<Region>();
			tempRegions.add(model);
			regionService.batchSaveOrUpdate(tempRegions);
			state = SUCCESS_STATE;

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
	@RequiresPermissions("deleteRegion")
	public String delete() {

		try {
			String[] idArray = ids.split(",");

			regionService.batchDelete(idArray);

			standardJsonObject.put("affectRow", idArray.length);
			state = SUCCESS_STATE;
		} catch (Exception e) {
			state = SERVERERROR_STATE;
			e.printStackTrace();
		}
		return this.reponseJson(null);
	}

}
