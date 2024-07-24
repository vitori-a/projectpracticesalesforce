# Integração ViaCEP com Salesforce
### Visão Geral
O searchCEP é um Lightning Web Component (LWC) desenvolvido para o Salesforce que permite aos usuários buscar informações de endereço usando um código postal brasileiro (CEP) via a API do ViaCEP. Com este componente, os usuários podem digitar um CEP, visualizar os detalhes do endereço correspondente e salvar essas informações no registro Account no Salesforce.

### Funcionalidades
- **Consulta de CEP:** Permite ao usuário buscar os detalhes de um endereço a partir da API do ViaCEP inserindo um CEP.
- **Exibição de Endereço:** Exibe as informações do endereço recuperadas da API, incluindo rua, bairro, cidade, estado, etc.
- **Salvar no Salesforce:** Possibilita salvar os detalhes do endereço recuperado em um registro de Account no Salesforce.

### Componentes
#### Classe Apex: CEPController
- **Propósito:** Gerencia a lógica para consultar a API do ViaCEP e atualizar o registro de Account no Salesforce.
#### Lightning Web Component: searchCEP
**Propósito:** Fornece a interface do usuário para:
- Digitar um CEP.
- Visualizar os detalhes do endereço.
- Salvar as informações no registro de Account.
