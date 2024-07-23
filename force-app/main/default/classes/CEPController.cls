public without sharing class CEPController {
   
    @AuraEnabled
    public static Address searchCEP(String cep){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/'+cep+'/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Address results = new Address();
        if(response.getStatusCode() == 200) {
           
            results = (Address) JSON.deserialize(response.getBody(), Address.class);
            system.debug(results);
            system.debug(cep);
        }

        return results;
    }

    @AuraEnabled
    public static Id updateAddressAccount(
        String accountId, String cep, String logradouro, String localidade, String uf, String pais) {

        Account acc = new Account(Id = accountId);
        acc.BillingPostalCode = cep;
        acc.BillingCity = localidade;
        acc.BillingState = uf;
        acc.BillingStreet = logradouro;
        acc.BillingCountry = pais;
            
        acc.ShippingPostalCode = cep;
        acc.ShippingCity = localidade;
        acc.ShippingState = uf;
        acc.ShippingStreet = logradouro;
        acc.ShippingCountry = pais;

        System.debug('cep: ' + cep);
        update acc;
        return acc.Id;
    }

    public class Address {
        @AuraEnabled
        public String cep {get;set;}
        @AuraEnabled
        public String logradouro {get;set;}
        @AuraEnabled
        public String complemento {get;set;}
        @AuraEnabled
        public String bairro {get;set;}
        @AuraEnabled
        public String localidade {get;set;}
        @AuraEnabled
        public String uf {get;set;}
    }
}