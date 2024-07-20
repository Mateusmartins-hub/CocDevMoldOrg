/*******************************************************************************
*                     Copyright (C) 2013 - Cloud2b
*-------------------------------------------------------------------------------
*
* This class reports logging limits processed in Salesforce
* NAME: LogLimits.cls
* AUTHOR: ROGERIO ALVARENGA                         DATE: 18/01/2013
*
*******************************************************************************/

public with sharing class LogLimits {
  
  //Print all Log Limits
  //@aHeader (Header Text can be anything. Ex: before execute query)
  //@aFullLog (Sets if the log will be complete or not)
  public static void print( String aHeader, boolean aFullLog )
  {
    List< String > lLog = new List< String >();
    
    lLog.add( '\n*************** ' + aHeader + ' ***************' );
    lLog.add( 'Log Limits (Processed/Total Number):' );
    lLog.add( format( 'SOQL Queries', Limits.getQueries(), Limits.getLimitQueries() ) );
    lLog.add( format( 'Records that can be processed', Limits.getDmlRows() ,Limits.getLimitDmlRows() ) );
    lLog.add( format( 'DML statements', Limits.getDmlStatements(), Limits.getLimitDmlStatements() ) );
    lLog.add( format( 'Script statements', Limits.getScriptStatements(), Limits.getLimitScriptStatements() ) );
    
    if ( aFullLog )
    {
        lLog.add( format( 'Aggregate queries', Limits.getAggregateQueries(), Limits.getLimitAggregateQueries() ) );
        lLog.add( format( 'Web service statements', Limits.getCallouts(), Limits.getLimitCallouts() ) );
        lLog.add( format( 'Child relationship', Limits.getChildRelationshipsDescribes(), Limits.getLimitChildRelationshipsDescribes() ) );
        lLog.add( format( 'CPU time', Limits.getCpuTime(), Limits.getLimitCpuTime() ) );
        lLog.add( format( 'Email invocations', Limits.getEmailInvocations(), Limits.getLimitEmailInvocations() ) );
        lLog.add( format( 'Field describe', Limits.getFieldsDescribes(), Limits.getLimitFieldsDescribes() ) );
        lLog.add( format( 'Field set describe', Limits.getFieldSetsDescribes(), Limits.getLimitFieldSetsDescribes() ) );
        lLog.add( format( 'Future annotation', Limits.getFutureCalls(), Limits.getLimitFutureCalls() ) );
        lLog.add( format( 'Amount of memory', Limits.getHeapSize(), Limits.getLimitHeapSize() ) );
        lLog.add( format( 'PicklistEntry objects', Limits.getPicklistDescribes(), Limits.getLimitPicklistDescribes() ) );
        lLog.add( format( 'QueryLocator', Limits.getQueryLocatorRows(), Limits.getLimitQueryLocatorRows() ) );
        lLog.add( format( 'Records returned', Limits.getQueryRows(), Limits.getLimitQueryRows() ) );
        lLog.add( format( 'RecordTypeInfo objects', Limits.getRecordTypesDescribes(), Limits.getLimitRecordTypesDescribes() ) );
        lLog.add( format( 'SOSL queries', Limits.getSoslQueries(), Limits.getLimitSoslQueries() ) );
    }
    //system.debug( String.join( lLog, '\n' ) );
  }
  
  private static String format( String aIndicator, Integer aUsed, Integer aTotal )
  {
    return '\t-> ' + aIndicator + ': ' + aUsed + ' / ' + aTotal;
  }

}