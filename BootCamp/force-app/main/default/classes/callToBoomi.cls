public with sharing class callToBoomi {
@future (callout=true) 
    
    public static void postToBoomi(String id){ 
        //Geneartes JSON
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        //The example doesnt line up with the tempalte for writeStringField
        gen.writeStringField('OpptyID', Id);
        gen.writeEndObject();
        String jsonS = gen.getAsString();
        System.debug('jsonmaterials' + jsonS);

        //generates the HTTP Request
        HttpRequest req = new HttpRequest();
        //I need to figure out my endpoint, ideally, ill name it as below
        req.setEndpoint('{https://test.connect.boomi.com}');
        req.setMethod('POST');

        //Passes in Body Generated above 
        req.setBody(jsonS);

        //Hardcoding username and password
        String Username = '{bryce.kilker@atginfo.com}';
        String password = '{3Threeblindmice}';

        //Encodes Username and Password for Basic Auth Call
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        req.setHeader('Authorization', authorizationHeader);

        //Get Response status
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('res.getBodyAsBlob ' + res.getBodyAsBlob());
        System.debug('res.getStatus ' + res.getStatus());
    }
  
}
