public class WeatherGetRequest {

    public static void fetchTemperature(String cityCountryName){
        
        List<Opportunity> opp = [SELECT ID FROM OPPORTUNITY WHERE COUNTRY__C = 'India'];
        //Create data
        String accessKey = '0916f328a325b3fd7ea99aa377ef825a';		//public is not allowed on local
        
        //HTTP callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.weatherstack.com/current?access_key='+accessKey+'&query='+cityCountryName);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug(res.getBody());
        
        WeatherResponseWrapper wres = WeatherResponseWrapper.parse(res.getBody());
        //wres = wres.parse(res.getBody());
        System.debug(wres.current.temperature);
        
        for(Opportunity op:opp){
            op.Temperature__c = wres.current.temperature;
        }
        update opp;
        System.debug(opp);
    }
}