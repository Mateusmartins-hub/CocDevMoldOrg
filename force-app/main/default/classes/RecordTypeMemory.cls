/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
* Recupera a identificação de um tipo de registro
* NAME: RecordTypeForTest.cls
* AUTHOR: CARLOS CARVALHO                            DATE: 01/02/2013
*
*******************************************************************************/
public with sharing class RecordTypeMemory {

  //Method that stores all record types
  private static Map< String, Map< String, Id > > fRecTypes = new Map< String, Map< String, Id > >();
  
  static {
    //Get All recordtypes of environment
    List< RecordType > lList = [ select id, SobjectType, DeveloperName from RecordType ];
    for ( RecordType lRec : lList )
    {
      //Create map of map (MAP1:KEY=SobjectType and VALUE=MAP || MAP2: KEY=DeveloperName and VALUE=RecordTypeId)
      Map< String, Id > lObjMap = fRecTypes.get( lRec.SobjectType );
      if ( lObjMap == null )
      {
        lObjMap = new Map< String, Id >();
        fRecTypes.put( lRec.SobjectType, lObjMap );
      }
      lObjMap.put( lRec.DeveloperName, lRec.id );
    }
  }
  
  //Get recordType record
  //@aObj (API Object Name)
  //@aDevName (Developer Name of Object)
  public static id getRecType( String aObj, String aDevName )
  {
    Map< String, Id > lObjMap = fRecTypes.get( aObj );
    if ( lObjMap == null ) return null;
    return lObjMap.get( aDevName );
  }
}