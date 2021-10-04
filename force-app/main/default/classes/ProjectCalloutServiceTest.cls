@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  
  @isTest
    static void testCalloutSuccess(){
        Account acc = new Account();
        acc.name 	= 'ACME Corp, Inc.';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name 		= 	'Super-Duper Big Deal';
        opp.StageName	=	'Qualification';
        opp.AccountId 	= 	acc.Id;
        opp.CloseDate 	= 	Date.today().addDays(10);
        opp.Amount 		= 	10000;
        opp.Type		=	'New Project';
        insert opp;
        
        List<id> oppId = new List<id>();
        for(Opportunity op : [select id from Opportunity where Id =: opp.Id])
        {
            oppId.add(op.id);
        }
        
        ServiceTokens__c serviceToken = new ServiceTokens__c();
        serviceToken.Name = 'ProjectServiceToken';
        serviceToken.Token__c = 'XYZ';
        insert serviceToken;
        
        Test.setMock(HttpCalloutMock.class, new  ProjectCalloutServiceMock());
        //Opportunity opp = [Select Id, StageName FROM Opportunity Limit 1];
        Test.startTest();
        ProjectCalloutService.PostOpportunityToPMS(oppId);
        ProjectCalloutService.QueueablePMSCall queJob = new ProjectCalloutService.QueueablePMSCall(oppId);
        //queJob.QueueablePMSCall(oppId);
        Id jobId = System.enqueueJob(queJob);
        Test.stopTest();
        
        Opportunity ops = [select id,StageName from Opportunity where Id =: opp.Id];
        system.assertEquals('Submitted Project', ops.StageName);
    }
}