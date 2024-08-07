public without sharing class CEPController {
   
    @AuraEnabled
    public static Endereco searchCEP(String cep){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/'+cep+'/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Endereco results = new Endereco();
        if(response.getStatusCode() == 200) {
            results = (Endereco) JSON.deserialize(response.getBody(), Endereco.class);
            system.debug(results);
            system.debug(cep);
        }
        return results;
    }

    @AuraEnabled
    public static Id updateBillingAddress(String accountId, String cep, String logradouro, String localidade, String uf, String numero) {
        Account acc = new Account(Id = accountId);
        acc.BillingPostalCode = cep;
        acc.BillingCity = localidade;
        acc.BillingState = uf;
        acc.BillingStreet = logradouro;
        acc.BillingCountry = 'Brasil';
        update acc;
        return acc.Id;
    }

    @AuraEnabled
    public static Id updateShippingAddress(String accountId, String cep, String logradouro, String localidade, String uf, String numero) {
        Account acc = new Account(Id = accountId);
        acc.ShippingPostalCode = cep;
        acc.ShippingCity = localidade;
        acc.ShippingState = uf;
        acc.ShippingStreet = logradouro;
        acc.ShippingCountry = 'Brasil';
        update acc;
        return acc.Id;
    }

    public class Endereco {
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
