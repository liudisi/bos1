package cn.zzrfdsn.customerService.dao;

import java.util.List;

import cn.zzrfdsn.customerService.model.Customer;

public interface ICustomerDao{
	
	
	List<Customer> findAdll();

	List<Customer> findNoAssociationDecidedzone();

	List<Customer> findHasAssociationDecidedzone(String decidedzone_id);

	Integer updateAssociationDecidedzone(String decidedzone_id, int... ids);

	Customer findCustomerByTelephone(String telephone);
	
	
}
