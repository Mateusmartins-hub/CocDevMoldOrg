/*******************************************************************************
*                     Copyright (C) 2012 - Cloud2b
*-------------------------------------------------------------------------------
*
* This class does semaphore control
* NAME: Semaphoro.cls
* AUTHOR: ROGERIO ALVARENGA                         DATE: 21/12/2012
*
*******************************************************************************/
public with sharing class Semaphore {
  
  //Set that store record ids
  @TestVisible
  private static Set< String > fAlreadyExecution = new Set< String >();
  
  //Validate if the record was previously run.
  public static boolean hasExec( ID aObject, boolean aSave )
  {
  	//Validate if fAlreadyExecution contains the record id and return TRUE
    if ( fAlreadyExecution.contains( aObject ) ) return true;
    //Validate if aSave parameter equals TRUE and store the record id in fAlreadyExecution set
    if ( aSave ) fAlreadyExecution.add( aObject );
    //Returns false
    return false;
  }

}