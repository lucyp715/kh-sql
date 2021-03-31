package member.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import member.model.vo.Member;
/**
 * 
 * DAO
 * Data Access Object
 * 
 * 1. jdbc driver 클래스 등록(dbms별로 제공) : 최초 1회
 * 2. db connection객체 생성 : dbserver url, user, password
 * 3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
 * 4. 쿼리전송(실행) - 결과값
 * 4.1 select문인 경우 결과집합을 자바객체(list)에 옮겨담기
 * 5. 트랜잭션처리(commit, rollback)
 * 6. 자원반납
 * 
 * 이렇게 한 번 DB에 갔다오는 과정 마무리
 * 
 */
public class MemberDAO {
	
	private String driverClass = "oracle.jdbc.OracleDriver"; //필드로 빼둔것
	//사용드라이버타입@ip주소:port:sid(접속db명)
	private String url = "jdbc:oracle:thin:@localhost:1521:xe"; //localhost : 내 컴퓨터 의미
	private String user = "student";
	private String password = "student";
	
	/**
	 * 
	 *1. jdbc driver 클래스 등록(dbms별로 제공) : 최초 1회
	 */
	public MemberDAO() {
		 /*
	       * C:\oraclexe\app\oracle\product\11.2.0\server\jdbc\lib
	       * 들어가서 이클립스의 루트디렉토리 lib 폴더에다가 ojbc6.jar 파일을 복사해서 붙여넣는다.
	       * 
	       * 그냥 웹상에서 바로 다운로드 받아서 사용해도 된다.
	       * 
	       * 루트 디렉토리의 Properties - Java Build Path - Libraries - Add JARs...
	       * 위에서 넣어두었던 lib 폴더의 ojbc6.jar파일 추가하고 Apply
	       * 
	       */

		try {
			Class.forName(driverClass);
			//클래스를 찾지 못했을 때 발생하는 오류
		} catch (ClassNotFoundException e) {
			System.out.println("ojdbc6.jar를 확인하세요.");
			e.printStackTrace();
		}
	}
	/**
	 * 2. db connection객체 생성 : dbserver url, user, password
	 * 3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
	 * 4. 쿼리전송(실행) - 결과값
	 * 4.1 select문인 경우 결과집합을 자바객체(list)에 옮겨담기
	 * 5. 트랜잭션처리(commit, rollback)
	 * 6. 자원반납
	 * @param member
	 * @return
	 */
	  public int insertMember(Member member) {
	      
	      Connection conn = null; //jdbc api중 하나
	      PreparedStatement pstmt = null; //Statement의 하위 인터페이스
	      // 실제 데이터의 값은 ?로 대체. 값 9개이므로 ? 9개
	      // sql 작성할 때 주의점 : ;(세미콜론)을 찍지 않는다.
	      // 공백 주의(2개 3개는 괜찮지만 없는게 문제)
	      String sql = "insert into member "
	            + "values(?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate)";
	      int result = 0;
	      
	      
	      // 2. db connection 객체 생성 : dbserver url, user, password
	      try {
	         conn = DriverManager.getConnection(url, user, password);
	         //자동커밋 사용안함(트랜잭션 처리는 java앱에서 주도적으로 처리하겠음.)
	         conn.setAutoCommit(false);
	         
	         //3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
				pstmt = conn.prepareStatement(sql);//미완성쿼리전달
				//Statement객체 생성후 ?에 값대입 쿼리 완성
				//매개변수에 넘어온 member객체에서 각 값을 꺼내어서 전달해주는 과정
				pstmt.setString(1, member.getMemberId());
				pstmt.setString(2, member.getPassword());
				pstmt.setString(3, member.getMemberName());
				pstmt.setString(4, member.getGender());
				pstmt.setInt(5, member.getAge());
				pstmt.setString(6, member.getEmail());
				pstmt.setString(7, member.getPhone());
				pstmt.setString(8, member.getAddress());
				pstmt.setString(9, member.getHobby());
			//enrolldate는 sysdate처리할 것이라 대입은 안 해도 된다.  
	         
	         // 4. 쿼리전송(실행) - 결과값
	         // DML인 경우는 int값(처리된 행의 수)이 리턴됨
	         result = pstmt.executeUpdate(); //dml인 경우 executeUpdate
	          
	        // 4_1. select문인 경우 결과집합을 자바객체(list)에 옮겨 담기
	         
	         // 5. 트랜잭션처리(commit, rollback)
	         if(result > 0) conn.commit();
	         else conn.rollback();
	         
	      } catch (Exception e) {
	         e.printStackTrace();
	         
	      } finally {
//	         6. 자원반납 : 생성 역순 pstmt conn
	         try {
	            pstmt.close();
	            conn.close();
	         } catch (Exception e) {
	            e.printStackTrace();
	         }
	      }
	      
	      return result;
//	      아까 돌려받은 result값을 리턴 !!!!!!반드시 하십쇼!!!!!!
	   }
	/**
	 * 2. db connection객체 생성 : dbserver url, user, password
	 * 3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
	 * 4. 쿼리전송(실행) - 결과값
	 * 4.1 select문인 경우 결과집합을 자바객체(list)에 옮겨담기
	 * 5. 트랜잭션처리(commit, rollback)
	 * 6. 자원반납
	 */
	  
	  public List<Member> selectALL() {
		  Connection conn = null;
		  PreparedStatement pstmt = null;
		  String sql = "select * from member order by enroll_date desc";
		  ResultSet rset = null;
		  List<Member> list = null;
		 
		  try {
			// 2. db connection객체 생성 : dbserver url, user, password
			conn = DriverManager.getConnection(url, user, password);
			
			 // 3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
			pstmt = conn.prepareStatement(sql);
			 // 4. 쿼리전송(실행) - 결과값
			//DQL select문인 경우에는 executeQuery()호출 -> ResultSet
			rset = pstmt.executeQuery();
			
			 // 4.1 select문인 경우 결과집합을 자바객체(list)에 옮겨담기
			list = new ArrayList<>(); //ArrayList객체 할당
			while(rset.next()) { //next 다음요소가 있는지 iterator랑 같다
				//한행의 컬럼정보에 접근할 수 있다.
				//한행 -> member vo객체
				Member member = new Member();     
				//db컬럼명 대소문자 없이 작성할것              db쪽 컬럼명으로 적어야한다
				member.setMemberId(rset.getString("member_id"));
	            member.setPassword(rset.getString("password"));
	            member.setMemberName(rset.getString("member_name"));
	            member.setGender(rset.getString("gender"));
	            member.setAge(rset.getInt("age"));
	            member.setEmail(rset.getString("email"));
	            member.setPhone(rset.getString("phone"));
	            member.setAddress(rset.getString("address"));
	            member.setHobby(rset.getString("hobby"));
	            member.setEnrollDate(rset.getDate("enroll_date"));
				
	            //list에 추가
	            list.add(member);				
			}
			 // 5. 트랜잭션처리(commit, rollback)
			//select문 트랜잭션처리 불필요
		} catch (Exception e) {
			e.printStackTrace();
		}
		 // 6. 자원반납
		  try {
			rset.close();
			pstmt.close();
			  conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		// System.out.println("list@dao = " + list);
		return list;
	}
	public Member searchMemberId(String memberId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "select * from member where member_id = '" + memberId + "'";
		ResultSet rset = null;
		Member member = null;
		
		try {
			// 2. db connection객체 생성 : dbserver url, user, password
			conn = DriverManager.getConnection(url, user, password);
			 // 3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
			pstmt = conn.prepareStatement(sql);
			// 4. 쿼리전송(실행) - 결과값
			rset = pstmt.executeQuery();
		
			// 4.1 select문인 경우 결과집합을 자바객체(list)에 옮겨담기
			
			while(rset.next()) {
				member = new Member(); 
				member.setMemberId(rset.getString("member_id")); // db컬럼명은 대소문자 구분없이 작성
				member.setPassword(rset.getString("password"));
				member.setMemberName(rset.getString("member_name"));
				member.setGender(rset.getString("gender"));
				member.setAge(rset.getInt("age"));
				member.setEmail(rset.getString("email"));
				member.setPhone(rset.getString("phone"));
				member.setAddress(rset.getString("address"));
				member.setHobby(rset.getString("hobby"));
				member.setEnrollDate(rset.getDate("enroll_date"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				//* 6. 자원 반납
				rset.close();
				pstmt.close();
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		

		return member;
	}
	public List<Member> searchMemberName(String memberName) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "select * from member where member_name = '" + memberName +"'";
		ResultSet rset = null;
		List<Member> list = new ArrayList<>();
		
		try {
			// 2. db connection객체 생성 : dbserver url, user, password
			conn = DriverManager.getConnection(url, user, password);
			// 3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
			pstmt = conn.prepareStatement(sql);
			//DQL select문인 경우에는 executeQuery()호출 -> ResultSet
			rset = pstmt.executeQuery();
			
			// 4.1 select문인 경우 결과집합을 자바객체(list)에 옮겨담기
			while(rset.next()) {
				Member member = new Member();
				member.setMemberId(rset.getString("member_id"));
				member.setPassword(rset.getString("password"));
				member.setMemberName(rset.getString("member_name"));
				member.setGender(rset.getString("gender"));
				member.setAge(rset.getInt("age"));
				member.setEmail(rset.getString("email"));
				member.setPhone(rset.getString("phone"));
				member.setAddress(rset.getString("address"));
				member.setHobby(rset.getString("hobby"));
				member.setEnrollDate(rset.getDate("enroll_date"));
				
				list.add(member);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				//* 6. 자원 반납
				rset.close();
				pstmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return list;

	}
	public int deleteMember(String memberId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "delete from member where member_id = '" + memberId + "'";
		int result = 0;
		
		try {
			//2. DB connection객체 생성 : dbserver url, user, password
			conn = DriverManager.getConnection(url,user,password);
			//3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
			pstmt = conn.prepareStatement(sql);
			//4. 쿼리전송(실행) - 결과값 
			result = pstmt.executeUpdate();
			
			if(result > 0) conn.commit();
	         else conn.rollback();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				pstmt.close();
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	public int updateMember(Member member) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "update member set "
				   + "password = ?, "
				   + "member_name = ?, "
				   + "gender = ?, "
				   + "age = ?, "
				   + "email = ?, "
				   + "phone = ?, "
				   + "address = ?, "
				   + "hobby = ? "
				   + "where member_id = ?";
		int result = 0;
		
		try {
			//2. db connection객체 생성 : dbserver url, user, password
			conn = DriverManager.getConnection(url, user, password);
			//자동커밋 사용안함
			conn.setAutoCommit(false);
			
			//3. 쿼리문 생성 및 Statement객체(PreparedStatement) 생성
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, member.getPassword());
			pstmt.setString(2, member.getMemberName());
			pstmt.setString(3, member.getGender());
			pstmt.setInt(4, member.getAge());
			pstmt.setString(5, member.getEmail());
			pstmt.setString(6, member.getPhone());
			pstmt.setString(7, member.getAddress());
			pstmt.setString(8, member.getHobby());
			pstmt.setString(9, member.getMemberId());
			//4. 쿼리전송(실행) - 결과값
			result = pstmt.executeUpdate();
			
			//5. 트랜잭션처리(commit, rollback)
			if(result > 0) conn.commit();
			else conn.rollback();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//6. 자원반납
			try {
				pstmt.close();
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	
	
}