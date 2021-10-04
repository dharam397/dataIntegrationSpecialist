public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(List<ID> oppList){
        //Query all opportunities and get required fields
        List<Opportunity> opps = [SELECT AccountId, Account.name,Amount,CloseDate,Id,Name FROM Opportunity where Id IN: oppList];
        List<ServiceTokens__c> keyList = [Select Token__c from ServiceTokens__c];
        System.debug('keyList'+keyList);
        String key = '';
        if(keyList.size()>0)
        	key = keyList[0].Token__c;
        List<Opportunity> oppsSubmitted = new List<Opportunity>();
        //set request body for each opportunity
        for(Opportunity oppToPost : opps){
            String body = '{'+
                '"opportunityId":'+ oppToPost.Id +','+
                '"opportunityName":'+ oppToPost.Name +','+
                '"accountName":'+ oppToPost.Account.name +','+
                '"closeDate":'+ oppToPost.CloseDate +','+
                '"amount":'+ oppToPost.Amount +','+
                '}';
            
            //post data for each opportunity
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:ProjectService');
            req.setMethod('POST');
            req.setBody(body);
            req.setHeader('token', key);
            req.setHeader('Content-Type','application/json;charset=UTF-8');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Response status'+res.getStatus());
            if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
                oppToPost.StageName = 'Submitted Project';
            }else
                oppToPost.StageName = 'Resubmit Project';
            oppsSubmitted.add(oppToPost);
        }
        update oppsSubmitted;
    }
    //Queuable inner class to handle asynchronous requests
    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        List<Id> oppsList {get;set;}
        public QueueablePMSCall(List<Id> oppList){
            //Set the list of IDs for the context
            This.oppsList = oppList;
        } 
        public void execute(QueueableContext qc) {
            //call method from parent
                postOpportunityToPMS(oppsList);
        }
    }
}