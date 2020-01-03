package cn.zzrfdsn.customerService.service;

import java.util.List;

import javax.jws.WebService;

import cn.zzrfdsn.customerService.model.Customer;

@WebService
public interface ICustomerService {

	public List<Customer> findAll();

	public List<Customer> findNoAssociationDecidedzone();

	public List<Customer> findHasAssociationDecidedzone(String decidedzone_id);

	public Integer associationDecidedzone(String decidedzone_id, int... ids);
	
	public Customer findCustomerByTelephone(String telephone);
}
