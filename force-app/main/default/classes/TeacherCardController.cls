/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
*
* TeacherCard's controller class.
*
* NAME: TeacherCardController.cls
* AUTHOR: MARCOS DOBROWOLSKI                        DATE: 2013/06/19
*
*******************************************************************************/


public with sharing class TeacherCardController {

  public class TeacherCardObject {
    public Integer index { get; set; }
    public Contact teacher { get; set; }
    public list<Institution> institutions { get; set; }
    public set<String> printableYears { get; set; }
    public list<Sample> materialSentP { get; set; }
    public list<Sample> materialSentV { get; set; }
    public list<Sample> materialVisit { get; set; }
    
    public map<Id, Institution> mapInstitution { get; set; }
    
    public TeacherCardObject () {
      institutions = new list<Institution>();
      mapInstitution = new map<Id, Institution>(); 
      printableYears = new set<String>();
      materialSentP = new list<Sample>();
      materialSentV = new list<Sample>();
      materialVisit = new list<Sample>();
    }
  }

  public class Institution {
    public Id contactId { get; set; }
    public Account_Contact__c accountContact { get; set; }
    public set<String> printableYears { get; set; }
    public list<Asset> adoptions { get; set; }
    
    public Institution () {
      printableYears = new set<String>();
      adoptions = new list<Asset>();
    }
  }

  public class Sample {
    public String sampleDate { get; set; }
    public String sampleTitle { get; set; }
    public String sampleAuthor { get; set; }
  }


  public list<TeacherCardObject> lstTeacher { get; set; }

  public TeacherCardController ( ) {

    lstTeacher = new list<TeacherCardObject>();
    set<String> setPrintYear = new set<String>();

    // Receives an Account Id
    Id mainId = Apexpages.currentPage().getParameters().get('id');


    // It verifies what kind of object owns the ID. If it is an Account, executes the query searching for the related 
    // contacts. If it is a Contact, put it on the Contact list and executes the regular process
    set<Id> setCttId = new set<Id>(); 
    if ( mainId.getSObjectType() == Account.sObjectType ) {
      // Retrieves all the Contacts (Teachers) referred to this account
      for ( Account_Contact__c accCtt : [ SELECT Id, Contact__c, Account__c FROM Account_Contact__c 
                                          WHERE Account__c = :mainId AND BR_Inactive__c = false ] ){
        setCttId.add( accCtt.Contact__c );
      }
    } else if ( mainId.getSObjectType() == Contact.sObjectType ) {
      setCttId.add( mainId );
    }

    // Retrieves the Contact data and stores it in a TeacherCardObject
    Integer count = 0;
    map<Id, TeacherCardObject> mapCttTeacher = new map<Id, TeacherCardObject>();
    for ( Contact ctt : [ SELECT Id, Name, BR_Address_Sidewalk__c, BR_Address__c, BR_Address_number__c, BR_Address_complement__c, 
                                 BR_Address_district__c, BR_Address_zip_code__c, BR_Address_city__c, BR_Address_state__c,
                                 BR_Area_code__c, BR_Area_code_cel__c, Phone, Fax, MobilePhone, BR_RG__c, Email, 
                                 BR_Contact_Birthdate__c, BR_CPF__c, Adocoes_Imprimir__c
                          FROM Contact WHERE id = :setCttId ] )
    {
      TeacherCardObject teacher = new TeacherCardObject();
        teacher.index = count++;
        teacher.teacher = ctt;
        
        // Breakes the list of printable years and stores into the teacher
        if ( ctt.Adocoes_Imprimir__c != null ) {
          for ( String year : ctt.Adocoes_Imprimir__c.split(';', 0) ) {
            teacher.printableYears.add( year );             
          }
          setPrintYear.addAll( teacher.printableYears );
        }
        
        mapCttTeacher.put( ctt.Id, teacher );
        lstTeacher.add( teacher );
    }
    //--- 
    
    // Searchs every Account vinculed to the Contacts and creates an Institution to stores the data
    // The Account Id and what Year is printable are stored too
    set<Id> setAccId = new set<Id>();
    for ( Account_Contact__c accCtt :  [ SELECT Id, Account__c, Contact__c, BR_AcademicRole__c, Account__r.Name, 
                                                Account__r.Adocoes_Imprimir__c
                                         FROM Account_Contact__c WHERE Contact__c = :setCttId AND BR_Inactive__c = false ] )
    {
      // Gets the coresponding teacher to this account 
      TeacherCardObject teacher = mapCttTeacher.get( accCtt.Contact__c );
      // Creates a new Institution 
      Institution place = new Institution();
        place.contactId = accCtt.Contact__c;
        place.accountContact = accCtt;
        
      // If the Teacher exists, add the institution to him
      if ( teacher != null ) {
        teacher.institutions.add( place );
        teacher.mapInstitution.put( accCtt.Account__c, place );
        
        setAccId.add( accCtt.Account__c );

        // Breakes the list of printable years and stores on the institution
        if ( accCtt.Account__r.Adocoes_Imprimir__c != null ) {
          for ( String year : accCtt.Account__r.Adocoes_Imprimir__c.split(';', 0) ) {
            place.printableYears.add( year );             
          }
          setPrintYear.addAll( place.printableYears );
        }
      }
    }
    //---
    
    // Adoptions (Assets)
    // Retrieves all the Assets (Adoptions) from the Account, and add the Asset to the institution 
    list<Asset> lstAsset = [ SELECT AccountId, BR_University_Course__r.Name, Product2.Name, BR_Product_Competitor__r.Name, BR_Editora__c,
                                    Quantity, BR_Course_Discipline__r.Name, BR_Year__c, BR_Compras__c, BR_Term__c, ContactId
                             FROM Asset WHERE AccountId = :setAccId AND ContactId = :setCttId AND BR_Year__c = :setPrintYear ];
    
    for ( Asset adoption : lstAsset ) {
      TeacherCardObject teacher = mapCttTeacher.get ( adoption.ContactId );
      if ( teacher == null ) continue;

      Institution inst = teacher.mapInstitution.get( adoption.AccountId );
      if ( inst == null ) continue;
      
      if ( mainId.getSObjectType() == Account.sObjectType && inst.printableYears.contains( adoption.BR_Year__c ) ) {
        inst.adoptions.add( adoption );
      }

      if ( mainId.getSObjectType() == Contact.sObjectType && teacher.printableYears.contains( adoption.BR_Year__c ) ) {
        inst.adoptions.add( adoption );
      }
    }
    //---


    // Samples ( Opportunities )
    Id RecTypeSampleOrder   = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_University'); 
    Id RecTypeStockWithdraw = RecordTypeMemory.getRecType('Opportunity', 'Sample_Order_Transit_Stock_Withdraw'); 

    // Gets all the Opportunities and his OpportunityLineItens, for each teacher and institution
    for ( Opportunity opp : [ SELECT Id, RecordTypeId, AccountId, BR_Request_Type__c, CloseDate, BR_Contact__c, 
                                   ( SELECT OpportunityId, PricebookEntry.Product2.Name, PricebookEntry.Product2.BR_Author_name__c 
                                     FROM OpportunityLineItems )
                              FROM Opportunity 
                              WHERE ( AccountId = :setAccId AND BR_Contact__c = :setCttId )
                              AND ( ( RecordTypeId = :RecTypeSampleOrder AND BR_Request_Type__c = 'Amostra Livro') 
                                 OR ( RecordTypeId = :RecTypeSampleOrder AND BR_Request_Type__c = 'Amostra Digital' )
                                 OR ( RecordTypeId = :RecTypeStockWithdraw ) ) ] )
    {

      // Puts the Sample object into the Teacher Object
      TeacherCardObject teacher = mapCttTeacher.get ( opp.BR_Contact__c );
      if ( teacher == null ) continue;

      // Creates sample objects with the Opportunity Data
      if ( opp.RecordTypeId == RecTypeSampleOrder && opp.BR_Request_Type__c == 'Amostra Livro' ) {
        for ( OpportunityLineItem oppLI : opp.OpportunityLineItems ) {
          Sample book = new Sample();
            book.sampleDate = opp.CloseDate != null ? opp.CloseDate.Day() + '/' + opp.CloseDate.Month() + '/' + opp.CloseDate.Year() : '';
            book.sampleTitle = oppLI.PricebookEntry.Product2.Name;
            book.sampleAuthor = oppLI.PricebookEntry.Product2.BR_Author_name__c;
          teacher.materialSentP.add( book );
        }
      } else if ( opp.RecordTypeId == RecTypeSampleOrder && opp.BR_Request_Type__c == 'Amostra Digital' ) {
        for ( OpportunityLineItem oppLI : opp.OpportunityLineItems ) {
          Sample book = new Sample();
            book.sampleDate = opp.CloseDate != null ? opp.CloseDate.Day() + '/' + opp.CloseDate.Month() + '/' + opp.CloseDate.Year() : '';
            book.sampleTitle = oppLI.PricebookEntry.Product2.Name;
            book.sampleAuthor = oppLI.PricebookEntry.Product2.BR_Author_name__c;
          teacher.materialSentV.add( book );
        }
      } else if ( opp.RecordTypeId == RecTypeStockWithdraw ){
        for ( OpportunityLineItem oppLI : opp.OpportunityLineItems ) {
          Sample book = new Sample();
            book.sampleDate = opp.CloseDate != null ? opp.CloseDate.Day() + '/' + opp.CloseDate.Month() + '/' + opp.CloseDate.Year() : '';
            book.sampleTitle = oppLI.PricebookEntry.Product2.Name;
            book.sampleAuthor = oppLI.PricebookEntry.Product2.BR_Author_name__c;
          teacher.materialVisit.add( book );
        }
      }
      //---
    }
  }
}