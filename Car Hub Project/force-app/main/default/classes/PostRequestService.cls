public class PostRequestService {

    /*public static void sendPostRequest() {
        // Step 1: Create wrapper instance
        RequestWrapper reqWrapper = new RequestWrapper();
        reqWrapper.name = 'Apple MacBook Pro 16';
        
        // Step 2: Create nested data object
        RequestWrapper.Data productData = new RequestWrapper.Data();
        productData.year = 2019;
        productData.price = 1849.99;
        productData.CPUmodel = 'Intel Core i9';
        productData.HardDiskSize = '1 TB';
        
        reqWrapper.data = productData;
        
        // Step 3: Serialize to JSON
        String jsonBody = JSON.serialize(reqWrapper);
        System.debug('Generated JSON: ' + jsonBody);
        
        // Step 4: Prepare HTTP callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.restful-api.dev/objects');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonBody);
        
        // Step 5: Send HTTP Request
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        System.debug('Response Status: ' + res.getStatus());
        System.debug('Response Body: ' + res.getBody());
    }*/
    
    
    public static void sendPostRequest(String name, Integer year, Decimal price, String cpu, String disk) {
        RequestWrapper reqWrapper = new RequestWrapper();
        reqWrapper.name = name;
        
        RequestWrapper.Data productData = new RequestWrapper.Data();
        productData.year = year;
        productData.price = price;
        productData.CPUmodel = cpu;
        productData.HardDiskSize = disk;
        
        reqWrapper.data = productData;
        
        String jsonBody = JSON.serialize(reqWrapper);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.restful-api.dev/objects');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonBody);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        System.debug('Response: ' + res.getBody());
    }


}