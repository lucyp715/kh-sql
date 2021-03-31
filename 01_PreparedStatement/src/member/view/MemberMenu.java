package member.view;

import java.util.List;
import java.util.Scanner;

import member.controller.MemberController;
import member.model.vo.Member;

public class MemberMenu {
	
	private Scanner sc = new Scanner(System.in);
//  위에서 MemberController를 생성해서 아래에서 controller로 가져다 쓸 수 있도록 해준다.
	private MemberController controller =  new MemberController();
	
	/**
	 * 2. 회원아이디 조회: 사용자로 부터 아이디를 입력받고 일치하는 회원 1명 조회
	 * 3. 회원이름 검색: 사용자로부터 이름을 입력받고, 일부라도 일치하는 회원 n명 조회
	 * 5. 회원정보 수정: 변경할 정보(아이디를 제외한 정보)를 입력받고, db에 반영하기(아이디, 등록일은 변경불가)
	 * 6. 회원탈퇴: 사용자로부터 아이디를 입력받고, 일치하는 회원1명 삭제
	 */
	public void mainMenu() {
		String menu = "-------- 회원 관리 프로그램 --------\n"
					+ "1. 회원 전체 조회\n"
					+ "2. 회원 아이디 조회\n"
					+ "3. 회원 이름 검색\n"
					+ "4. 회원 가입\n"
					+ "5. 회원 정보 수정\n"
					+ "6. 회원 탈퇴\n"
					+ "0. 프로그램 끝내기\n"
					+ "-------------------------------\n"
					+ "선택 : ";
		
		while(true) {
			System.out.print(menu);
			int choice = sc.nextInt();
			Member member = null; //우리가 만든 Member 객체 임포트
			int result = 0; //정수형 변수 처리결과를 result에 담을 것
			List<Member> list = null;
			String memberId = null;
			String memberName = null;
			switch(choice) {
				case 1: 
					//1. controller요청
					list = controller.selectALL();
					//2.회원목록 출력
					displayMemberList(list);
					break;
				case 2: 
					//사용자 입력값
					sc.nextLine();
					System.out.print("Id를 입력해주세요 : ");
					memberId = sc.nextLine();
					//controller요청
					member = controller.searchMemberId(memberId);
					displayMemberId(member);
					break;
				case 3: //회원 이름 검색
					//사용자 입력값
					sc.nextLine();
					System.out.print("이름을 입력해주세요 : ");
					memberName = sc.nextLine();
					//controller요청
					list = controller.searchMemberName(memberName);
					displayMemberList(list);
					break;
				case 4: 
					//1.사용자 입력값 -> member객체 생성
					member = inputMember();
					//2.controller에 insert요청
					result = controller.insertMember(member);
					//System.out.println(result); // 그래서 출력끝날떄 1이라고뜬다
					displayMsg(result == 1 ? "회원가입 성공!" : "회원가입 실패!");
					break;
				case 5:
					//1.사용자 입력값 -> member객체 생성
					member = updateMember();
					//2.controller
					result = controller.updateMember(member);
					displayMsg(result == 1 ? "회원정보 수정 성공!" : "회원정보 수정 실패!");
					break;
				case 6: 
					//1.사용자 입력값 -> member객체 생성
					sc.nextLine();
					System.out.print("Id를 입력해주세요 : ");
					memberId = sc.nextLine();
					//2.controller에 delete요청
					result = controller.deleteMember(memberId);
					displayMsg(result == 1 ? "회원탈퇴 성공!" : "회원탈퇴 실패!");
					break;
				case 0: 
					System.out.print("정말로 끝내시겠습니까?(y/n) : ");
					if(sc.next().charAt(0) == 'y')
						return; //run으로 돌아간다.
					break;
				default : System.out.println("잘못 입력하셨습니다.");
			}
			
			
		}
		
	}
	  
	
	
	private Member updateMember() {
		System.out.println("변경할 회원정보를 입력하세요.");
		System.out.println("-------------------------------");
		System.out.print("아이디 : ");
		String memberId = sc.next();
		System.out.print("비밀번호 : ");
		String password = sc.next();
		System.out.print("이름 : ");
		String memberName = sc.next();
		System.out.print("나이 : ");
		int age = sc.nextInt();
		System.out.print("성별(M/F) : ");
		String gender = sc.next().toUpperCase(); //소문자로 입력해도 대문자로 바꾸어 줌
		System.out.print("이메일 : ");
		String email = sc.next();
		System.out.print("전화번호(-빼고 입력) : ");
		String phone = sc.next();
		sc.nextLine(); //개행문자 날리기용
//      next 다음에 nextLine을 쓰면 사이에 개행문자 날리기용 nextLine이 필요
		System.out.print("주소 : ");
		String address = sc.nextLine();
		System.out.print("취미(,으로 나열) : ");
		String hobby = sc.nextLine();
		return new Member(memberId, password, memberName, gender, 
						  age, email, phone, address, hobby, null);
	}



	private void displayMemberId(Member member) {
		if(member != null ) {
			System.out.println(member);
		}else {
			System.out.println("조회된 아이디가 없습니다.");
			
		}
		
	}

	/*
	    * 회원 목록 조회메소드
	    * (여러명 즉 여러행이겠지)
	    */
	   private void displayMemberList(List<Member> list) {
	      
	      System.out.println("=======================================");
	      //조회된 회원정보가 있을 때
	      if(list != null && !list.isEmpty()) {
	         
	         System.out.println("MemberId\t"
	                        + "MemberName\t"
	                        + "Gender\t"
	                        + "Age\t"
	                        + "Email\t"
	                        + "Phone\t"
	                        + "Address\t"
	                        + "Hobby\t"
	                        + "Enroll Date");
	         System.out.println("-----------------------------------------------------------------------------------------------");
				for(Member member : list)
					System.out.println(member);
	      }
	      //조회된 회원정보가 없을 때
	      else {
	         System.out.println("조회된 회원이 없습니다.");
	      }
	      System.out.println("=======================================");
	   }
	/**
	 * DML 처리 후에 사용자에게 피드백을 주는 메소드
	 */
	private void displayMsg(String msg) {
		System.out.println(msg);
	}

	/**
	 * 회원가입 메소드
	 * 사용자 입력처리
	 * @return
	 */
	private Member inputMember() {
		System.out.println("새로운 회원정보를 입력하세요.");
		System.out.println("-------------------------------");
		System.out.print("아이디 : ");
		String memberId = sc.next();
		System.out.println("비밀번호 : ");
		String password = sc.next();
		System.out.println("이름 : ");
		String memberName = sc.next();
		System.out.println("나이 : ");
		int age = sc.nextInt();
		System.out.println("성별(M/F) : ");
		String gender = sc.next().toUpperCase(); //소문자로 입력해도 대문자로 바꾸어 줌
		System.out.println("이메일 : ");
		String email = sc.next();
		System.out.println("전화번호(-빼고 입력) : ");
		String phone = sc.next();
		sc.nextLine(); //개행문자 날리기용
//      next 다음에 nextLine을 쓰면 사이에 개행문자 날리기용 nextLine이 필요
		System.out.println("주소 : ");
		String address = sc.nextLine();
		System.out.println("취미(,으로 나열) : ");
		String hobby = sc.nextLine();
		return new Member(memberId, password, memberName, gender, 
						  age, email, phone, address, hobby, null); //enrollDate는 null값으로 설정한다.

	}

	
	
}
