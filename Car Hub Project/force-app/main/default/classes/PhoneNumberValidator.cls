public class PhoneNumberValidator {
    public static void validatePhoneNumber(String phoneNumber,String countryCode){
        String endpoint = 'https://api.numlookupapi.com/v1/validate/'+phoneNumber+'?apikey=num_live_Nf2vjeM19tHdi42qQ2LaVVMg2IGk1ReU2BYBKnvm&country_code='+countryCode;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }
}