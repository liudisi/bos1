package cn.zzrfdsn.bos1.model;
// Generated 2019-8-14 14:29:26 by Hibernate Tools 5.0.6.Final

import java.util.Date;

/**
 * 工单
 */
public class Workbill implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	public static final String  TYPE_NEW = "新单";
	public static final String  TYPE_RECOVER = "催单";
	public static final String  TYPE_MODIFY = "改单";
	public static final String  TYPE_DESTRUCTION = "销单";
	
	public static final String  PICKSTATE_NO = "未取件";
	public static final String  PICKSTATE_RUNNING = "取件中";
	public static final String  PICKSTATE_YES = "已取件";
	
	//主键 工单号
	private String id;
	//所属通知单
	private Noticebill noticebill;
	//工单类型
	private String type;
	//取件状态
	private String pickstate;
	//工单生成时间
	private Date buildtime;
	//催单次数
	private Integer attachbilltimes;
	//备注
	private String remark;
	//取派员
	private Staff staff;

	public Workbill() {
	}

	public Workbill(String id, Date buildtime) {
		this.id = id;
		this.buildtime = buildtime;
	}

	public Workbill(String id, Noticebill noticebill, String type, String pickstate, Date buildtime,
			Integer attachbilltimes, String remark, Staff staff) {
		this.id = id;
		this.noticebill = noticebill;
		this.type = type;
		this.pickstate = pickstate;
		this.buildtime = buildtime;
		this.attachbilltimes = attachbilltimes;
		this.remark = remark;
		this.staff = staff;
	}
	
	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Noticebill getNoticebill() {
		return this.noticebill;
	}

	public void setNoticebill(Noticebill noticebill) {
		this.noticebill = noticebill;
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPickstate() {
		return this.pickstate;
	}

	public void setPickstate(String pickstate) {
		this.pickstate = pickstate;
	}

	public Date getBuildtime() {
		return this.buildtime;
	}

	public void setBuildtime(Date buildtime) {
		this.buildtime = buildtime;
	}

	public Integer getAttachbilltimes() {
		return this.attachbilltimes;
	}

	public void setAttachbilltimes(Integer attachbilltimes) {
		this.attachbilltimes = attachbilltimes;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Staff getStaff() {
		return staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}


}
