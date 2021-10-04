@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
  
    @isTest
    static void testBillingService(){
        //set mock
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        //create credentails
        ServiceCredentials__c credential = new ServiceCredentials__c();
        credential.Name 	= 	'BillingServiceCredential';
        credential.Username__c	=	'username';
        credential.Password__c	=	'password';
        insert credential;
        
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
        List<Project__c> projects = new List<Project__c>();
        Project__c prj = new Project__c();
        prj.Billable_Amount__c 	=	1000;
        prj.End_Date__c			=	Date.today().addDays(100);
        prj.Start_Date__c		=	Date.today();
        prj.Status__c			= 	'Running';
        prj.Name				=	'Test Project';
        prj.ProjectRef__c		=	'12345567';
        prj.Opportunity__c		= 	opp.Id;
        insert prj;
        
        
        Test.startTest();
        prj.Status__c = 'Billable';
        projects.add(prj);
        //update prj;
        BillingCalloutService.callBillingService(projects);
        Test.stopTest();
    }
}