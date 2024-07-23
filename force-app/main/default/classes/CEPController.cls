public without sharing class CEPController {
   
    @AuraEnabled
    public static Endereco consultarCEP(String cep){
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