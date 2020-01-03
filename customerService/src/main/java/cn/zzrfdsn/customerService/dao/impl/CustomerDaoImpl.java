package cn.zzrfdsn.customerService.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;

import cn.zzrfdsn.customerService.dao.ICustomerDao;
import cn.zzrfdsn.customerService.model.Customer;

@Repository("customerDao")
public class CustomerDaoImpl extends JdbcDaoSupport implements ICustomerDao {

	private final Logger LOGGER=Logger.getLogger(getClass());
	@Autowired
	public void mySetDataSource(DataSource dataSource) {
		super.setDataSource(dataSource);
	}

	@Override
	public List<Customer> findAdll() {
		
		return getJdbcTemplate().query("SELECT * FROM customer", new RowMapper<Customer>() {

			@Override
			public Customer mapRow(ResultSet resultSet, int arg1) throws SQLException {
				Customer customer=new Customer();
				customer.setId(resultSet.getInt("id"));
				customer.setName(resultSet.getString("name"));
				customer.setStation(resultSet.getString("station"));
				customer.setTelephone(resultSet.getString("telephone"));
				customer.setAddress(resultSet.getString("address"));
				customer.setDecidedzone_id(resultSet.getString("decidedzone_id"));
				return customer;
			}
			
		});
		
	}

	@Override
	public List<Customer> findNoAssociationDecidedzone() {
		return  getJdbcTemplate().query("SELECT * FROM customer WHERE decidedzone_id is null", new RowMapper<Customer>() {

			@Override
			public Customer mapRow(ResultSet resultSet, int arg1) throws SQLException {
				Customer customer=new Customer();
				customer.setId(resultSet.getInt("id"));
				customer.setName(resultSet.getString("name"));
				customer.setStation(resultSet.getString("station"));
				customer.setTelephone(resultSet.getString("telephone"));
				customer.setAddress(resultSet.getString("address"));
				customer.setDecidedzone_id(resultSet.getString("decidedzone_id"));
				return customer;
			}
			
		});
	}

	@Override
	public List<Customer> findHasAssociationDecidedzone(String decidedzone_id) {
		return getJdbcTemplate().query("SELECT * FROM customer WHERE decidedzone_id=?", new RowMapper<Customer>() {

			@Override
			public Customer mapRow(ResultSet resultSet, int arg1) throws SQLException {
				Customer customer=new Customer();
				customer.setId(resultSet.getInt("id"));
				customer.setName(resultSet.getString("name"));
				customer.setStation(resultSet.getString("station"));
				customer.setTelephone(resultSet.getString("telephone"));
				customer.setAddress(resultSet.getString("address"));
				customer.setDecidedzone_id(resultSet.getString("decidedzone_id"));
				return customer;
			}
			
		},decidedzone_id);
	}

	@Override
	public Integer updateAssociationDecidedzone(String decidedzone_id, int ... ids) {
		//先把开始关联的全部设为null
		
		getJdbcTemplate().update("UPDATE customer SET decidedzone_id=NULL WHERE decidedzone_id=?", decidedzone_id);
		
		int[] batchUpdate = null;
		if(ids!=null) {
			for (int id : ids) {
				batchUpdate= getJdbcTemplate().batchUpdate("UPDATE customer SET decidedzone_id='"+decidedzone_id+"' WHERE id="+id);
			}
		}
		
		return batchUpdate==null?0:batchUpdate.length;
	}

	@Override
	public Customer findCustomerByTelephone(String telephone) {
		try {
			return getJdbcTemplate().queryForObject("SELECT * FROM customer WHERE telephone=?",new RowMapper<Customer>() {
				@Override
				public Customer mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					Customer customer=new Customer();
					customer.setId(resultSet.getInt("id"));
					customer.setName(resultSet.getString("name"));
					customer.setStation(resultSet.getString("station"));
					customer.setTelephone(resultSet.getString("telephone"));
					customer.setAddress(resultSet.getString("address"));
					customer.setDecidedzone_id(resultSet.getString("decidedzone_id"));
					return customer;
				}}, telephone);
		} catch (DataAccessException e) {
			logger.error(e);;
			return null;
		}
	}

}
