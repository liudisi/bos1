package cn.zzrfdsn.bos1.model;
// Generated 2019-8-14 14:29:26 by Hibernate Tools 5.0.6.Final

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * 业务受理通知单
 */
public class Noticebill implements java.io.Serializable {
	
	private static final long serialVersionUID = 1L;
	public static final String ORDERTYPE_AUTO="自动分单";
	public static final String ORDERTYPE_NONAUTO="人工分单";

	//主键
	private String id;
	//取派员编号
	private Staff staff;	
	//客户编号
	private String customerId;
	//客户姓名
	private String customerName;
	//联系人
	private String delegater;
	//联系人号码
	private String telephone;
	//取件地址
	private String pickaddress;
	//收件地址
	private String arrivecity;
	//发货产品
	private String product;
	//预约取件日期
	private Date pickdate;
	//件数
	private Integer num;
	//重量
	private Double weight;
	//体积
	private String volume;
	//备注
	private String remark;
	//分单类型
	private String ordertype;
	//受理人，(当前操作者)
	private String userId;
	
	//包含的工单
	private Set<Workbill> workbills = new HashSet<Workbill>(0);

	public Noticebill() {
	}

	public Noticebill(String id) {
		this.id = id;
	}

	public Noticebill(String id, Staff staff, String customerId, String customerName, String delegater,
			String telephone, String pickaddress, String arrivecity, String product, Date pickdate, Integer num,
			Double weight, String volume, String remark, String ordertype, String userId, Set<Workbill> workbills) {
		this.id = id;
		this.staff = staff;
		this.customerId = customerId;
		this.customerName = customerName;
		this.delegater = delegater;
		this.telephone = telephone;
		this.pickaddress = pickaddress;
		this.arrivecity = arrivecity;
		this.product = product;
		this.pickdate = pickdate;
		this.num = num;
		this.weight = weight;
		this.volume = volume;
		this.remark = remark;
		this.ordertype = ordertype;
		this.userId = userId;
		this.workbills = workbills;
	}

	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Staff getStaff() {
		return staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

	public String getCustomerId() {
		return this.customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getCustomerName() {
		return this.customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getDelegater() {
		return this.delegater;
	}

	public void setDelegater(String delegater) {
		this.delegater = delegater;
	}

	public String getTelephone() {
		return this.telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getPickaddress() {
		return this.pickaddress;
	}

	public void setPickaddress(String pickaddress) {
		this.pickaddress = pickaddress;
	}

	public String getArrivecity() {
		return this.arrivecity;
	}

	public void setArrivecity(String arrivecity) {
		this.arrivecity = arrivecity;
	}

	public String getProduct() {
		return this.product;
	}

	public void setProduct(String product) {
		this.product = product;
	}

	public Date getPickdate() {
		return this.pickdate;
	}

	public void setPickdate(Date pickdate) {
		this.pickdate = pickdate;
	}

	public Integer getNum() {
		return this.num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}

	public Double getWeight() {
		return this.weight;
	}

	public void setWeight(Double weight) {
		this.weight = weight;
	}

	public String getVolume() {
		return this.volume;
	}

	public void setVolume(String volume) {
		this.volume = volume;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getOrdertype() {
		return this.ordertype;
	}

	public void setOrdertype(String ordertype) {
		this.ordertype = ordertype;
	}

	public String getUserId() {
		return this.userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Set<Workbill> getWorkbills() {
		return this.workbills;
	}

	public void setWorkbills(Set<Workbill> workbills) {
		this.workbills = workbills;
	}

}
