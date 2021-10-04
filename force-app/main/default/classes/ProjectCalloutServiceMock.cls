@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock  {
    //Implement http mock callout here
    global HTTPResponse respond(HTTPRequest req){
       /* String body = '{'+
            '"opportunityId": "00641000004EKmFAAW",'+
            '"opportunityName": "Super-Duper Big Deal",'+
            '"accountName": "ACME Corp, Inc.",'+
            '"closeDate": "2016-10-30",'+
            '"amount": 150000'+
            '}'; */
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}