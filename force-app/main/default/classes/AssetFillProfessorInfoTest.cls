/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
*
* AssetFillProfessorInfo trigger class test. 
* NAME: AssetFillProfessorInfoTest.cls
* AUTHOR: ANDRÉ SANTOS DE MEDEIROS                       DATE: 15/03/2013
*
*******************************************************************************/
@isTest
private class AssetFillProfessorInfoTest {
  
  static testMethod void myUnitTest() {
    //Get record types for Product2 and Account
    Id lProductRecordType = RecordTypeMemory.getRecType( 'Product2', 'Product_COC' );
    Id lAccountRecordType = RecordTypeMemory.getRecType( 'Account', 'Languages' );
    //Creation and insertion of professor-related objetcs
    Account lAccount = SObjectInstance.getAccount( lAccountRecordType );
    System.assert( Database.insert( lAccount, false ).isSuccess() );
    Contact br_contact = SObjectInstance.getContact(lAccount.Id);
    System.assert( Database.insert( br_contact, false ).isSuccess() );
    University_courses__c course = new University_courses__c();
    course.Account__c = lAccount.Id;
    System.assert( Database.insert( course, false ).isSuccess() );
    University_Course_Contact__c professor = new University_Course_Contact__c();
    professor.BR_Contact__c = br_contact.Id;
    professor.BR_course__c = course.Id;
    System.assert( Database.insert( professor, false ).isSuccess() );
    //Creation and insertion of discipline-related objects
    Course_Structure_Discipline__c discipline = new Course_Structure_Discipline__c();
    discipline.Type__c = 'DISCIPLINA';
    discipline.BR_Discipline_code__c = 'AAA';
    System.assert( Database.insert( discipline, false ).isSuccess() );
    Univ_Course_Structure__c course_discipline = new Univ_Course_Structure__c();
    course_discipline.Discipline__c = discipline.Id;
    course_discipline.University_course__c = course.Id;
    System.assert( Database.insert( course_discipline, false ).isSuccess() );
    //Creates an asset and associates it with previously created objects and a new Product2
    Product2 product = SObjectInstance.getProduct2( lProductRecordType );
    System.assert( Database.insert( product, false ).isSuccess() );
    Asset lNewAsset = new Asset();
    lNewAsset.Name = 'Adoção';
    lNewAsset.BR_University_Course__c = professor.BR_course__c;
    lNewAsset.Product2Id = product.Id;
    lNewAsset.BR_Professor__c = professor.Id;
    lNewAsset.BR_Course_Discipline__c = course_discipline.Id;
    //Resets governor limits and inserts the new asset
    //Test.startTest();
    //System.assert( Database.insert( lNewAsset, false ).isSuccess() );
    //Test.stopTest();
  }
}