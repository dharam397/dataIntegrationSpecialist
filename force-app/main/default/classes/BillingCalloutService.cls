public class BillingCalloutService {
    //Implement business and callout logic methods here
    Static Boolean billServiceCalled = False;
    public static void callBillingService(List<Project__c> projects){
        List<Project__c> billableProjects = new List<Project__c>();
        //fecth username and password from custom label
        ServiceCredentials__c creds = [Select Id, Name, Username__c, Password__c FROM ServiceCredentials__c WHERE Name = 'BillingServiceCredential'];
        String username = creds.Username__c;
        String password = creds.Password__c;
        String prjRef = '';
        Double billAmount = 0;
        for(Project__c prj : projects){
            if(prj.Status__c == 'Billable'){
                // billableProjects.add(prj);
                prjRef 		= prj.ProjectRef__c;
                billAmount 	= prj.Billable_Amount__c;
                if(!billServiceCalled){
                    billProject(prjRef, billAmount, username, password);
                    billServiceCalled = True; 
                } 
            }
        }
    }
    @future(callout=true)
    public static void billProject(String prjReference, Double amount, String username, String password){
        Project__c prjToUpdate = [SELECT Billable_Amount__c,End_Date__c,Id,Name,Opportunity__c,ProjectRef__c,Start_Date__c,Status__c FROM Project__c WHERE ProjectRef__c =:prjReference];
        BillingServiceProxy.project projectParams = new BillingServiceProxy.project();
        projectParams.username = username;
        projectParams.password = password;
        projectParams.billAmount = amount;
        projectParams.projectid = prjReference;
        //BillingServiceProxy newBill = BillingServiceProxy();
        BillingServiceProxy.InvoicesPortSoap11 billingService = new BillingServiceProxy.InvoicesPortSoap11();
        String response = billingService.billProject(projectParams);
        System.debug('---response---'+response);
        if(response=='ok'){
            prjToUpdate.Status__c = 'Billed';
        }
        update prjToUpdate;
    }
}