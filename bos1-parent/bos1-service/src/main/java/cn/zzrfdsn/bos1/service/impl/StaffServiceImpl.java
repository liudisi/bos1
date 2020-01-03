package cn.zzrfdsn.bos1.service.impl;

import java.io.Serializable;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.dao.IStaffDao;
import cn.zzrfdsn.bos1.model.Staff;
import cn.zzrfdsn.bos1.service.IStaffService;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class StaffServiceImpl implements IStaffService {

	@Autowired
	private IStaffDao staffdao;
	
	public void setStaffdao(IStaffDao staffdao) {
		this.staffdao = staffdao;
	}



	@Override
	public Serializable save(Staff staff) {
		 return staffdao.save(staff);
	}



	@Override
	public void pageQuery(PageBean<Staff> pageBean) {
		staffdao.pageQuery(pageBean);
	}



	@Override
	public int batchDelete(String... ids) {
		int execute=0;
		if(ids!=null&&ids.length>0) {
			for (String id : ids) {
				execute+=staffdao.execute("staff.delete", id);
			}
		}
		return execute;
	}



	@Override
	public Staff findById(String id) {
		return staffdao.findById(id);
	}



	@Override
	public void update(Staff staff) {
		staffdao.update(staff);
	}



	@Override
	public List<Staff> findStaffListByGiveConditions(DetachedCriteria detachedCriteria) {
		return staffdao.detachedCriteriaQuery(detachedCriteria);
	}



	@Override
	public int batchRestore(String... ids) {
		int execute=0;
		if(ids!=null&&ids.length>0) {
			for (String id : ids) {
				execute+=staffdao.execute("staff.restore", id);
			}
		}
		return execute;
	}

}
