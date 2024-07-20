/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* RESPONSIBLE TO PERFORM DML FUNCTION ON Account_Segmentation__c OBJECT..
* 
* NAME: AccountSegmentationDAO.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 07/02/2013
*******************************************************************************/
public class AccountSegmentationDAO {
    
    //Get a list Account segmentation by a id list
    //@aListIdsAccSeg (Ids of Account segmentation)
    public static List< Account_Segmentation__c > getAccSegById( List< String > aListIdsAccSeg ){
    	return [ SELECT   
				Total_of_students_preparatory_course__c, Total_of_students_pre_school__c, 
				Total_of_students_kindergarden__c, 
				Total_of_students_EM__c, Total_of_students_EJA__c, Total_of_students_EI__c, 
				Total_of_students_EF__c, Total_of_students_EF2__c, Total_of_students_EF1__c, 
				RecordTypeId, Nbr_of_teachers_young_adults__c, 
				Nbr_of_teachers_semi_int__c, Nbr_of_teachers_semi_ext__c, Nbr_of_teachers_secondary__c, 
				Nbr_of_teachers_primary__c, Nbr_of_teachers_preparatory_course__c, 
				Nbr_of_teachers_pre_primary__c, Nbr_of_teachers_intensive__c, Nbr_of_teachers_extensive__c, 
				Nbr_of_teachers_exams__c, Nbr_of_teachers_child_5_years__c, 
				Nbr_of_teachers_child_4_years__c, Nbr_of_teachers_child_2_years__c, Nbr_of_teachers_child_1_year__c, 
				Nbr_of_teachers_business__c, Nbr_of_teachers_adults__c, Nbr_of_teachers_Terceirao__c, 
				Nbr_of_teachers_EM_4th_year__c, Nbr_of_teachers_EM_3rd_year__c, 
				Nbr_of_teachers_EM_2nd_year__c, Nbr_of_teachers_EM_1st_year__c, Nbr_of_teachers_EJA_EM__c, 
				Nbr_of_teachers_EJA_EF__c, Nbr_of_teachers_EF2_9th_year__c, 
				Nbr_of_teachers_EF2_8th_year__c, Nbr_of_teachers_EF2_7th_year__c, 
				Nbr_of_teachers_EF2_6th_year__c, Nbr_of_teachers_EF1_5th_year__c, 
				Nbr_of_teachers_EF1_4th_year__c, Nbr_of_teachers_EF1_3rd_year__c, 
				Nbr_of_teachers_EF1_2nd_year__c, Nbr_of_teachers_EF1_1st_year__c, 
				Nbr_of_students_young_adults__c, Nbr_of_students_semi_int__c, Nbr_of_students_semi_ext__c, 
				Nbr_of_students_secondary__c, Nbr_of_students_primary__c, 
				Nbr_of_students_preparatory_course__c, Nbr_of_students_pre_primary__c, 
				Nbr_of_students_intensive__c, Nbr_of_students_extensive__c, Nbr_of_students_exams__c, 
				Nbr_of_students_business__c, Nbr_of_students_adults__c, Nbr_of_students_Terceirao__c, 
				Nbr_of_students_EM_4th_year__c, Nbr_of_students_EM_3rd_year__c, 
				Nbr_of_students_EM_2nd_year__c, Nbr_of_students_EM_1st_year__c, Nbr_of_students_EJA_EM__c,
				 Nbr_of_students_EJA_EF__c, Nbr_of_students_EF2_9th_year__c, 
				Nbr_of_students_EF2_8th_year__c, Nbr_of_students_EF2_7th_year__c, 
				Nbr_of_students_EF2_6th_year__c, Nbr_of_students_EF1_5th_year__c, 
				Nbr_of_students_EF1_4th_year__c, Nbr_of_students_EF1_3rd_year__c, 
				Nbr_of_students_EF1_2nd_year__c, Nbr_of_students_EF1_1st_year__c, 
				Nbr_of_child_5_years__c, Nbr_of_child_4_years__c, Nbr_of_child_3_years__c, 
				Nbr_of_child_2_years__c, Nbr_of_child_1_year__c, Nbr_of_Teachers_child_3_years__c, 
				Name, LastModifiedDate, LastModifiedById, IsDeleted, Id, Current_year__c,
				CreatedDate, CreatedById, BR_How_many_uses_systems_education__c, Account__c
				FROM Account_Segmentation__c 
				WHERE Id =: aListIdsAccSeg ];
    }
      
    
    public static List<Account_Segmentation__c> queryQuadrante(String accountId , String ano){
    	return [SELECT Quadrante_Idiomas__c, Total_of_students_EI__c, Total_of_students_EF__c, Total_of_students_EM__c, BR_Total_Adults_Idiomas__c, Total_Alunos_Idiomas__c
					FROM Account_Segmentation__c
						WHERE Account__c=: accountId and Current_year__c =: ano];
    }
}