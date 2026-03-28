public class HarryPotterSpells {
    public static void potterSpells(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://hp-api.onrender.com/api/spells');
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }
}