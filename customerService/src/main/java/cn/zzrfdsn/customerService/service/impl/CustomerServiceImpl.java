package cn.zzrfdsn.customerService.service.impl;

import java.util.List;

import javax.jws.WebService;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.customerService.dao.ICustomerDao;
import cn.zzrfdsn.customerService.model.Customer;
import cn.zzrfdsn.customerService.service.ICustomerService;

@Transactional
@WebService
@Service("customerService")
public class CustomerServiceImpl implements ICustomerService {
	private final Logger logger = Logger.getLogger(getClass());
	@Autowired
	private ICustomerDao customerDao;

	@Override
	public List<Customer> findAll() {

		logger.info("CustomerServiceImpl:findAll被调用了");

		return customerDao.findAdll();
	}

	@Override
	public List<Customer> findNoAssociationDecidedzone() {
		return customerDao.findNoAssociationDecidedzone();
	}

	@Override
	public List<Customer> findHasAssociationDecidedzone(String decidedzone_id) {
		return customerDao.findHasAssociationDecidedzone(decidedzone_id);
	}

	@Override
	public Integer associationDecidedzone(String decidedzone_id, int... ids) {
		
		return customerDao.updateAssociationDecidedzone(decidedzone_id,ids);
	}

	@Override
	public Customer findCustomerByTelephone(String telephone) {
		return customerDao.findCustomerByTelephone(telephone);
	}
}
