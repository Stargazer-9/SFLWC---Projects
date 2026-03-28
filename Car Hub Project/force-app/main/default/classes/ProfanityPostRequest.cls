public class ProfanityPostRequest {
    public static void sendPostRequest(String msg){
        
        //Create data
        ProfanityWrapper profWrapr = new ProfanityWrapper();
        profWrapr.message = msg;
        
        //serialize data to JSON
        String jsonBody = JSON.serialize(profWrapr);
        
        //http callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://vector.profanity.dev');
        req.setMethod('POST');
        
        req.setHeader('content-type', 'application/json');
        req.setBody(jsonBody);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug(res.getStatus());
        System.debug(res.getBody());
    }
}