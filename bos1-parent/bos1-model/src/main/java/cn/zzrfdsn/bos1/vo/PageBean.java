package cn.zzrfdsn.bos1.vo;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;

/**
 * 分页bean
 * 
 * @author SYL
 *
 */
public class PageBean<T> {

public PageBean(int currentPage, int showSize, DetachedCriteria detachedCriteria) {
		super();
		this.currentPage = currentPage;
		this.showSize = showSize;
		this.detachedCriteria = detachedCriteria;
	}

	//	当前页
	private int currentPage;
//	每页显示条目数
	private int showSize;
//	总记录数
	private int total;
//	数据
	private List<T> rows;
//	查询条件
	private DetachedCriteria detachedCriteria;

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getShowSize() {
		return showSize;
	}

	public void setShowSize(int showSize) {
		this.showSize = showSize;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public List<T> getRows() {
		return rows;
	}

	public void setRows(List<T> rows) {
		this.rows = rows;
	}
	

	public DetachedCriteria getDetachedCriteria() {
		return detachedCriteria;
	}

	public void setDetachedCriteria(DetachedCriteria detachedCriteria) {
		this.detachedCriteria = detachedCriteria;
	}

	/**
	 * 获取开始索引
	 * 
	 * @return
	 */
	public int getStart() {

		return (this.currentPage - 1) * showSize;
	}

	public PageBean() {
		super();
	}

}
