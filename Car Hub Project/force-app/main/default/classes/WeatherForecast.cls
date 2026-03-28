public class WeatherForecast {
	
    public static void weatherForecast(String stateCode){
        HttpRequest req = new HttpRequest();
        String endpoint = 'https://date.nager.at/api/v3/PublicHolidays/2025/'+stateCode;
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug(response.getBody());
        
    }
}