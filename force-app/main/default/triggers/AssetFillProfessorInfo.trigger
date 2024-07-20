/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
* 
* Trigger that copies BR_Professor__r.BR_Contact__c and 
* BR_CourseDiscipline__r.Discipline__c fields from an asset to its ContactId and
* BR_Discipline__c fields, respectively.
* NAME: AssetFillProfessorInfo.trigger
* AUTHOR: ANDRÉ SANTOS DE MEDEIROS                       DATE: 15/03/2013
*
*******************************************************************************/
trigger AssetFillProfessorInfo on Asset (before insert, before update) {
  LogLimits.print('TRIGGER: AssetFillProfessorInfo - BEGIN CODE', false);
  //Data structures relative to ContactId field attribution
  Map< Asset, Id > assetProfessorMap = new Map< Asset, Id >();
  Map< Id, University_Course_Contact__c > professorMap;
  List< Id > professorIdList = new List< Id >();
  //Data structures relative to BR_Discipline__c field attribution
  Map< Asset, Id > assetDisciplineMap = new Map< Asset, Id >();
  Map< Id, Univ_Course_Structure__c > disciplineMap;
  List< Id > disciplineIdList = new List< Id >();
  //Populates lists and maps
  for( Asset lAsset : Trigger.new ){
    assetProfessorMap.put( lAsset, lAsset.BR_Professor__c );
    professorIdList.add( lAsset.BR_Professor__c );
    assetDisciplineMap.put( lAsset, lAsset.BR_Course_Discipline__c );
    disciplineIdList.add( lasset.BR_Course_Discipline__c );
  }
  LogLimits.print('TRIGGER: AssetFillProfessorInfo - AFTER FOR ASSET', false);
  //Get professors and disciplines refered by the assets being inserted or updated
  professorMap = new Map< Id, University_Course_Contact__c >( 
    [select BR_Contact__c, Id from University_Course_Contact__c where Id=:professorIdList] );
  disciplineMap = new Map< Id, Univ_Course_Structure__c >( 
    [select Discipline__c, Id from Univ_Course_Structure__c where Id=:disciplineIdList] );
  //Get the IDs of those professors and disciplines and sets assest's OwnerId and
  //BR_Discipline__c fields according to them.
  LogLimits.print('TRIGGER: AssetFillProfessorInfo - AFTER SELECTS', false);
  for( Asset lAsset : Trigger.new ){
    Id professorId = assetProfessorMap.get( lAsset ),
      disciplineId = assetDisciplineMap.get( lAsset );
    if( professorId != NULL )
      lAsset.ContactId = professorMap.get( professorId ).BR_Contact__c;
    if( disciplineId != NULL )
      lAsset.BR_Discipline__c = disciplineMap.get( disciplineId ).Discipline__c;
  }
  LogLimits.print('TRIGGER: AssetFillProfessorInfo - END CODE', false);
}