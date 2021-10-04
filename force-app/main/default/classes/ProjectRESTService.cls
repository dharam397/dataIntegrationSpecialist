@RestResource(urlMapping = '/project/*')
global with sharing class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status){
        /*
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        String returnMessage;
        //get request fields to populate 
        RequestWrapper requestWrap = (RequestWrapper)JSON.deserialize(requestString,RequestWrapper.class);
		*/
        List<Project__c> projects = [SELECT Billable_Amount__c,End_Date__c,Id,Name,Opportunity__c,ProjectRef__c,Start_Date__c,Status__c FROM Project__c WHERE ProjectRef__c = :ProjectRef];
        Project__c proj = new Project__c();
        if(projects.size()>0){
            proj = projects.get(0);
        }
        //Create a savePoint
        savePoint sp = Database.setSavepoint();
        //Create project record
        //Project__c proj = new Project__c();
        
        try{
            proj.ProjectRef__c 	= ProjectRef;
            proj.Name 			= ProjectName;
            proj.Opportunity__c = OpportunityId;
            proj.Start_Date__c 	= StartDate;
            proj.End_Date__c 	= EndDate;
            proj.Billable_Amount__c = Amount;
            proj.Status__c 		= Status;
            upsert proj ProjectRef__c;
        
        //update related opportunity
        Opportunity opp = [Select Id, Name, DeliveryInstallationStatus__c FROM Opportunity where Id=:OpportunityId];
        opp.DeliveryInstallationStatus__c	= 'In progress';
        update opp; 
        return 'OK'; 
        }catch(Exception e){
            Database.rollback(sp);
            return e.getMessage();
        }
    }
    
    /* to get Date value from String
    private Date getDate(String dateString){
        
    }
    */
    /*
    class RequestWrapper {
        public String ProjectRef;    
        public String ProjectName;  
        public String OpportunityId;
        public String StartDate;
        public String EndDate;
        public String Amount;
        public String Status;
     } */
    /*
    public static RequestWrapper parse(String json){
        return (RequestWrapper) System.JSON.deserialize(json, RequestWrapper.class);
    } */
}