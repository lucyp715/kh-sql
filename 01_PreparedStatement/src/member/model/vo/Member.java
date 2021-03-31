package member.model.vo;

import java.sql.Date;

/**
 * VO class 
 * Value Object 사용자 데이터가 담길 객체
 * 1. member테이블의 한행 == member객체하나
 * 2. member테이블의 컬럼 == member객체 필드
 *
 * 컬럼명과 필드명은 동일하게 작성한다.
 * db:member_id(snake casing)  <---> java:memberId(camel casing)
 * 호환가능한 자료형 처리 필수
 * db:char, varchar2 <----> java:String(char사용하지 말것)
 * db:number  		 <----> java:int, double
 * db:date, timestamp<----> java:sql.Date, sql.TimeStamp
 * 
 * db:date타입에는 시분초 정보가 존재하지만, jdbc과정에서 시분초는 유실된다.
 * 시분초정보가 필요하다면, timestamp를 사용할 것.
 */
public class Member {
	
	private String memberId;
	private String password;
	private String memberName;
	private String gender;		// char가 아닌 String사용할 것.
	private int age;
	private String email;
	private String phone;
	private String address;
	private String hobby;
	private Date enrollDate;	// java.sql.Date
	
	public Member() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Member(String memberId, String password, String memberName, String gender, int age, String email,
			String phone, String address, String hobby, Date enrollDate) {
		super();
		this.memberId = memberId;
		this.password = password;
		this.memberName = memberName;
		this.gender = gender;
		this.age = age;
		this.email = email;
		this.phone = phone;
		this.address = address;
		this.hobby = hobby;
		this.enrollDate = enrollDate;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getHobby() {
		return hobby;
	}

	public void setHobby(String hobby) {
		this.hobby = hobby;
	}

	public Date getEnrollDate() {
		return enrollDate;
	}

	public void setEnrollDate(Date enrollDate) {
		this.enrollDate = enrollDate;
	}

	@Override
	public String toString() {
		return memberId + "\t"  + memberName + "\t"
				+ gender + "\t" + age + "\t" + email + "\t" + phone + "\t" + address
				+ "\t" + hobby + "\t" + enrollDate;
	}
	
}
