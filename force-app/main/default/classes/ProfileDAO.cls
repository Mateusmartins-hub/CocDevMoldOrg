/**
 * Created by re035946 on 14/02/2018.
 */
public class ProfileDAO {
	public static Profile getProfileNameByProfileId(String profId){
		return [SELECT Id,
				Name
				From Profile
				WHERE Id =: profId Limit 1];
	}
}