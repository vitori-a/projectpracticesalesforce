import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { IsConsoleNavigation, getFocusedTabInfo, refreshTab } from 'lightning/platformWorkspaceApi';
import searchCEP from '@salesforce/apex/CEPController.searchCEP';
import updateBillingAddress from '@salesforce/apex/CEPController.updateBillingAddress';
import updateShippingAddress from '@salesforce/apex/CEPController.updateShippingAddress';

export default class SearchCEP extends LightningElement {
    @track cep;
    @api recordId;
    @track endereco;
    @track billingAddress = false;
    @track shippingAddress = false;
    @track showShippingQuestion = false;
    @track sameAsBilling = false;
    @track notSameAsBilling = false;
    @track showCEPForm = true;
    @track showSuccessMessage = false;
    
    @wire(IsConsoleNavigation) isConsoleNavigation;

    handleCEPChange(event) {
        this.cep = event.target.value;
    }

    handleLogradouroChange(event) {
        this.endereco.logradouro = event.target.value;
    }

    handleBairroChange(event) {
        this.endereco.bairro = event.target.value;
    }

    handleLocalidadeChange(event) {
        this.endereco.localidade = event.target.value;
    }

    handleUFChange(event) {
        this.endereco.uf = event.target.value;
    }

    searchCEP() {
        searchCEP({ cep: this.cep })
            .then(result => {
                this.endereco = result;                
                if(this.notSameAsBilling == true){
                    this.shippingAddress = true; 
                }else {
                    this.billingAddress = true;
                }
            })
            .catch(error => {
                console.error('Erro ao consultar CEP: ', error);
                this.showToast('Erro ao consultar CEP', 'Ocorreu um erro ao consultar o CEP. Por favor, tente novamente.', 'error');
            });
    }

    updateBillingAddress() {
        updateBillingAddress({
            accountId: this.recordId,
            cep: this.cep,
            logradouro: this.endereco.logradouro,
            uf: this.endereco.uf,
            localidade: this.endereco.localidade
        })
        .then(result => {
            this.showShippingQuestion = true;
            this.billingAddress = false;
            this.showCEPForm = false;
            this.showToast('Endereço de cobrança atualizado!', 'success');
            this.refreshTab();
        })
        .catch(error => {
            this.showToast('Erro ao atualizar endereço de cobrança!', 'error');
            console.error('Erro ao salvar: ', error);
        });
    }

    handleShippingQuestion(event) {
        this.sameAsBilling = event.target.value === 'yes';
        if (this.sameAsBilling) {
            this.updateShippingAddress();
            this.showShippingQuestion = false;
        } else {
            this.endereco = {};
            this.showCEPForm = true;
            this.billingAddress = false;
            this.shippingAddress = true; 
            this.notSameAsBilling = true;
            this.showShippingQuestion = false;
        }
    }

    updateShippingAddress() {
        updateShippingAddress({
            accountId: this.recordId,
            cep: this.cep,
            logradouro: this.endereco.logradouro,
            uf: this.endereco.uf,
            localidade: this.endereco.localidade
        })
        .then(result => {
            this.billingAddress = false;
            this.showShippingQuestion = false;
            this.shippingAddress = false;
            this.showCEPForm = false;
            this.showSuccessMessage = true;
            this.showToast('Endereço de entrega atualizado!', 'success');
            this.refreshTab();
        })
        .catch(error => {
            this.showToast('Erro ao atualizar endereço de entrega!', 'error');
            console.error('Erro ao salvar: ', error);
        });
    }

    showToast(title, variant) {
        const event = new ShowToastEvent({
            title: title,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    handleRefreshTab() {
        this.refreshTab();
    }

    async refreshTab() {
        if (!this.isConsoleNavigation) {
            return;
        }
        const { tabId } = await getFocusedTabInfo();
        await refreshTab(tabId, {
            includeAllSubtabs: true
        });
    }
}
