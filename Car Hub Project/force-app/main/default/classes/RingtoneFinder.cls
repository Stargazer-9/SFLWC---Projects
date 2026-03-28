public class RingtoneFinder {
    public static void ringtoneFinder(String phoneType) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://abhi-api.vercel.app/api/search/ringtone?text='+phoneType;
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
    }
}