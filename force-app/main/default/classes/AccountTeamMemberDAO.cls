/**
 * Created by re035946 on 22/02/2018.
 */
public class AccountTeamMemberDAO {
	public static List<AccountTeamMember> getMemberTeamListByAccountId(string accId){
		return [SELECT Id,
				TeamMemberRole,
				AccountAccessLevel
		FROM AccountTeamMember
		WHERE AccountId =: accId];
	}

	public static List<AccountTeamMember> getMemberTeamListByAccountIdAndRole(string accId, string papel){
		List<AccountTeamMember> membros = new List<AccountTeamMember>();
		membros.addAll([SELECT Id,
				AccountId,
				UserId,
				TeamMemberRole,
				AccountAccessLevel
				FROM AccountTeamMember
				WHERE AccountId =: accId
				AND TeamMemberRole =: papel]);
		return membros;
	}

	public static List<AccountTeamMember> getMemberTeamListBySetAccIdAndRole(Set<Id> setAccId, string papel){
		List<AccountTeamMember> membros = new List<AccountTeamMember>();
		membros.addAll([SELECT Id,
				AccountId,
				UserId,
				TeamMemberRole,
				AccountAccessLevel
				FROM AccountTeamMember
				WHERE AccountId =: setAccId
				AND TeamMemberRole =: papel]);
		return membros;
	}
}