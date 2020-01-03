package cn.zzrfdsn.bos1.service.impl;

import java.io.Serializable;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.model.Permit;
import cn.zzrfdsn.bos1.model.Role;
import cn.zzrfdsn.bos1.service.IRoleService;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class RoleServiceImpl implements IRoleService {

	@Autowired
	private IRoleDao roleDao;

	@Override
	public String saveOrUpdate(Role role, String permitIds) {
		String saveId = null;

		if (StringUtils.isNotBlank(permitIds)) {
			Set<Permit> permits = new HashSet<Permit>();
			String[] permitIdArr = permitIds.split(",");
			for (String permitId : permitIdArr) {
				Permit permit = new Permit();
				permit.setId(permitId);
				permits.add(permit);
			}
			role.setPermits(permits);
		}
		
		if (StringUtils.isBlank(role.getId())) {
			saveId = (String) roleDao.save(role);
		}else {
			roleDao.update(role);
		}

		return saveId;

	}

	@Override
	public void pageQuery(PageBean<Role> pageBean) {
		roleDao.pageQuery(pageBean);
	}

	@Override
	public List<Role> findAll() {
		return roleDao.findAll();
	}

	@Override
	public void delete(Role role) {
		role = roleDao.findById(role.getId());
		if (role.getCode().contentEquals("admin")) {
			throw new RuntimeException();
		}
		roleDao.delete(role);
	}

	@Override
	public Role findById(String id) {

		return StringUtils.isBlank(id) ? null : roleDao.findById(id);
	}

}
