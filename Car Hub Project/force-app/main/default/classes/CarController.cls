public with sharing class CarController {
    

    // @AuraEnabled(Cacheable=true)        // cacheable for get method
    // public static List<Car__c> getCars(){
    //     return [SELECT Id, Name, MSRP__c, Description__c, Category__c, Picture_URL__c FROM Car__c];
    // }

    
    //new logic based on filtered data received from UI, based on this query runs
    // wrapper class for different datatypes received from Car filters
    public class Filters{
        @AuraEnabled
        public String searchKey {get; set;}
        @AuraEnabled
        public Decimal maxPrice {get; set;}
        @AuraEnabled
        public String[] categories {get; set;}
        @AuraEnabled
        public String[] makeType {get; set;}
        
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Car__c> getCars(Filters filters){
        
        String key, whereClause = '';
        Decimal maxPrice;
        String[] categories, makeType, criteria = new List<String>{};
        
        if(filters != null){
            maxPrice = filters.maxPrice;
            categories = filters.categories;
            makeType = filters.makeType;

            if (!String.isEmpty(filters.searchKey)) {
                key = '%' + filters.searchKey + '%';    // dynamic concatenation
                criteria.add('Name LIKE :key');
            }
            if (maxPrice >= 0) {
                criteria.add('MSRP__c <= :maxPrice');
            }
            if (categories != null) {
                criteria.add('Category__c IN :categories');
            }
            if (makeType != null) {
                //using isEmpty()-string with zero length throws System.NullPointerException
                criteria.add('Make__c IN :makeType');
            }
            if (criteria.size() > 0) {
                whereClause = ' WHERE ' + String.join(criteria, ' AND ');
            }
        }
        
        // WITH SECURITY_ENFORCED CANNOT be used in dynamic SOQL (Database.query())
        String query = 'SELECT Id, Name, MSRP__c, Description__c, Category__c, Picture_URL__c FROM Car__c' + whereClause + ' ORDER BY Name';

        // to run dynamic queries
        return Database.query(query);
    }



    // to fetch similar cars details
    @AuraEnabled(cacheable=true)
    public static Car__c[] getSimilarCars(Id carId, String[] makeType){
        return [SELECT Id, Name, MSRP__c, Description__c, Category__c, Picture_URL__c, Make__c FROM Car__c WHERE Make__c IN :makeType AND Id != :carId];
    }
}
