package cn.zzrfdsn.bos1.model;
// Generated 2019-8-18 14:23:26 by Hibernate Tools 5.0.6.Final

import java.util.HashSet;
import java.util.Set;

/**
 * Permit generated by hbm2java
 */
public class Permit implements java.io.Serializable {
	private static final long serialVersionUID = 1L;

	private String id;
	private Permit parentPermit;
	private String name;
	private String code;
	private String description;
	private String page;
	private String generatemenu;
	private Integer zindex;
	private String menugroup;
	public String getMenugroup() {
		return menugroup;
	}

	public void setMenugroup(String menugroup) {
		this.menugroup = menugroup;
	}

	private Set<Role> roles = new HashSet<Role>(0);
	private Set<Permit> subPermits;
	
	public String getpId() {
		Permit parentPermit = this.getParentPermit();
		return parentPermit==null?"0":parentPermit.getId();
	}

	/**
	 * 用于返回树形结构数据
	 * @return
	 */
	public Set<Permit> getChildren() {
		return this.subPermits;
	}
	
	public String getText() {
		return this.name;
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Permit getParentPermit() {
		return parentPermit;
	}

	public void setParentPermit(Permit parentPermit) {
		this.parentPermit = parentPermit;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getPage() {
		return page;
	}

	public void setPage(String page) {
		this.page = page;
	}

	public String getGeneratemenu() {
		return generatemenu;
	}

	public void setGeneratemenu(String generatemenu) {
		this.generatemenu = generatemenu;
	}

	public Integer getZindex() {
		return zindex;
	}

	public void setZindex(Integer zindex) {
		this.zindex = zindex;
	}

	public Set<Role> getRoles() {
		return roles;
	}

	public void setRoles(Set<Role> roles) {
		this.roles = roles;
	}

	public Set<Permit> getSubPermits() {
		return subPermits;
	}

	public void setSubPermits(Set<Permit> subPermits) {
		this.subPermits = subPermits;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}