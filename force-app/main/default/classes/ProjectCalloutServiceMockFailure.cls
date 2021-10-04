@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here 
   global static HTTPResponse respond(HTTPRequest req){
        /*String body = '{'+
            '"opportunityId": "00641000004EKmFAAW",'+
            '"opportunityName": "Super-Duper Big Deal",'+
            '"accountName": "ACME Corp, Inc.",'+
            '"closeDate": "2016-10-30",'+
            '"amount": 150000'+
            '}';*/
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setBody(body);
        res.setStatusCode(400);
            return res;
    }
}