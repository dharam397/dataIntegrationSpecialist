@isTest
private class ProjectRESTServiceTest {
    //Implement Apex REST service tests here
    @isTest
    static void testRESTService(){
        //create opportunity
        opportunity  TestOpp=new opportunity ();
   date mydate = date.parse('12/27/2009');
   TestOpp.name='TestOpp1';
   TestOpp.StageName='Test';
   TestOpp.CloseDate=mydate ;
   insert TestOpp;
        
        //create project
        /*
        Project__c  proj=new Project__c ();
        proj.ProjectRef__c 	= '1235';
        proj.Name 			= 'Test Project';
        proj.Opportunity__c = TestOpp.Id;
        proj.Start_Date__c 	= Date.today();
        proj.End_Date__c 	= Date.today().addDays(10);
        proj.Billable_Amount__c = 1000;
        proj.Status__c 		= 'Billable';
        insert proj;
        ProjectRESTService reqst=new ProjectRESTService();
        String JsonMsg=JSON.serialize(reqst);
        */
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/project';  //Request URL
        req.httpMethod = 'POST';  //HTTP Request Type
        //req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        ProjectRESTService.postProjectData('12345', 'Test Proj', TestOpp.Id, Date.today(), Date.today().addDays(100), 10000, 'Billable');
        ProjectRESTService.postProjectData('', 'Test Proj', null, Date.today(), Date.today().addDays(100), 10000, 'Billable');
        update TestOpp;
        Test.stopTest();
    }
}