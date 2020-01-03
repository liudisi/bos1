package cn.zzrfdsn.bos1.utils;

import java.util.Date;
import java.util.List;

public class Student {

	private String name;
	
	private Integer age;
	
	private Character sex;
	
	private Date admissionDate;
	
	private List<String> courses;

	
	
	public Student(String name, Integer age, Character sex, Date admissionDate, List<String> courses) {
		super();
		this.name = name;
		this.age = age;
		this.sex = sex;
		this.admissionDate = admissionDate;
		this.courses = courses;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	public Character getSex() {
		return sex;
	}

	public void setSex(Character sex) {
		this.sex = sex;
	}

	public Date getAdmissionDate() {
		return admissionDate;
	}

	public void setAdmissionDate(Date admissionDate) {
		this.admissionDate = admissionDate;
	}

	public List<String> getCourses() {
		return courses;
	}

	public void setCourses(List<String> courses) {
		this.courses = courses;
	}
	
	
	
}
