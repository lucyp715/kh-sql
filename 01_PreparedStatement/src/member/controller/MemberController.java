package member.controller;

import java.util.List;

import member.model.dao.MemberDAO;
import member.model.vo.Member;

public class MemberController {

	private MemberDAO memberDAO = new MemberDAO();
	
	public int insertMember(Member member) {
		return memberDAO.insertMember(member);
	}

	public List<Member> selectALL() {
		return memberDAO.selectALL();
	}

	public Member searchMemberId(String memberId) {
		return memberDAO.searchMemberId(memberId);
	}

	public List<Member> searchMemberName(String memberName) {
		return memberDAO.searchMemberName(memberName);
	}

	public int deleteMember(String memberId) {
		return memberDAO.deleteMember(memberId);
	}

	public int updateMember(Member member) {
		return memberDAO.updateMember(member);
		
	}


}
