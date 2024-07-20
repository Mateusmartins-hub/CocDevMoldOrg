({
    validatePricebook : function(cmp) {
        cmp.set("v.isLoading", true);
        var action = cmp.get('c.getPricebook');
        action.setParams({id : cmp.get('v.amostraId')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retorno =  response.getReturnValue();
                if($A.util.isUndefinedOrNull(retorno))
                    this.setPricebooks(cmp);
                else {
                    cmp.set("v.selectedPricebook2Id", retorno);
                    cmp.set("v.selectingPriceBook", false);
                    this.setData(cmp);
                }
            }else if (state === "ERROR") {
                this.showToast('error', 'Erro', 'Erro, contate o Tech.');
            }
        });
        $A.enqueueAction(action);
    },

    setPricebooks : function(cmp) {
        var action = cmp.get('c.getPricebooks');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retorno =  response.getReturnValue();
                var pricebooks = [];
                retorno.forEach(function(item) {
                    pricebooks.push({ label : item.Name, value : item.Id});
                });
                cmp.set('v.pricebooks', pricebooks);
                cmp.set("v.isLoading", false);
            }else if (state === "ERROR") {
                this.showToast('error', 'Erro', 'Erro, contate o Tech.');
            }
        });
        $A.enqueueAction(action);
    },

	setColumns : function(cmp) {
        cmp.set('v.columnsProdsAdded', [
            {label: '', type: 'button', initialWidth: 65, typeAttributes: { label: { fieldName: 'actionLabel'}, title: '', name: 'add', iconName: 'utility:delete'}},
            {label: 'Produto', fieldName: 'ProductName', type: 'text'},
            {label: '* Quantidade', fieldName: 'Quantity', type: 'number', editable: true},
            {label: 'Preço de lista', fieldName: 'PricebookPrice', type: 'currency', cellAttributes: { alignment: 'left' }, typeAttributes: {currencyCode: 'BRL', maximumFractionDigits: 2, minimumFractionDigits: 2}},
            {label: 'Valor total', fieldName: 'TotalWithoutDiscountPrice', type: 'currency', cellAttributes: { alignment: 'left' }, typeAttributes: {currencyCode: 'BRL'}}
        ]);

		cmp.set('v.columnsProdsToAdd', [
            {label: '', type: 'button', initialWidth: 65, typeAttributes: { label: { fieldName: 'actionLabel'}, title: '', name: 'add', iconName: 'utility:add'}},
            {label: 'Produto', fieldName: 'ProductName', type: 'text'},
            {label: 'Preço de lista', fieldName: 'PricebookPrice', type: 'currency', cellAttributes: { alignment: 'left' }, typeAttributes: {currencyCode: 'BRL', maximumFractionDigits: 2, minimumFractionDigits: 2}},
            {label: 'Código', fieldName: 'ProductCode', type: 'text'}
        ]);
	},

    setAmostraId : function(cmp) {
        cmp.set("v.isLoading", false);
        var action = cmp.get('c.getAmostraId');
        action.setParams({id : cmp.get('v.recordId')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                const retorno = response.getReturnValue();                
                cmp.set('v.amostraId', retorno);
                this.setProdsAddedValidatePricebook(cmp);
            }else if (state === "ERROR") {
                var message = "Erro, contate o Tech.";

                let errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0)
                    message = errors[0].message;

                this.showToast('error', 'Erro', message);
                cmp.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(action);
    },

    savePricebook2IdAndItems : function(cmp) {
        cmp.set("v.isLoading", true);
        
        const hasError = this.validateQuantity(cmp);

        if (!hasError) {
            var action = cmp.get('c.savePricebookNItems');
            action.setParams({id : cmp.get('v.amostraId'), pricebookId : cmp.get('v.selectedPricebook2Id'), jsonItems : JSON.stringify(cmp.get('v.dataProdsAdded'))});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS') {
                    this.showToast('success', 'Success', 'Produtos atualizados com sucesso.');
                    $A.get('e.force:refreshView').fire();
                    $A.get('e.force:closeQuickAction').fire();
                    cmp.set("v.isLoading", false);
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({"url": "/" + cmp.get('v.amostraId')});
                    urlEvent.fire();
                } else if (state === "ERROR") {
                    var message = "Erro, contate o Tech.";

                    let errors = response.getError();
                    if (errors && Array.isArray(errors) && errors.length > 0)
                        message = errors[0].message;

                    this.showToast('error', 'Erro', message);
                    cmp.set("v.isLoading", false);
                }
            });
            $A.enqueueAction(action);
        } else
            this.showToast('error', 'Erro', 'É necessário indicar a quantidade antes de adicionar o produto');
            cmp.set("v.isLoading", false);
    },

    setData : function(cmp) {
        cmp.set("v.isLoading", true);
        var action = cmp.get('c.getProducts');
        action.setParams({pricebook2Id : cmp.get('v.selectedPricebook2Id')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retorno =  response.getReturnValue();
                var rs = [];
                var cont = 0;
                var prodsAdded = cmp.get('v.dataProdsAdded');
                retorno.forEach(function(item) {
                    var contem = false;

                    prodsAdded.forEach(function(iAdded) {
                       if(iAdded.ProductName == item.Product2.Name)
                           contem = true;
                    });

                    if(contem)
                        return;

                    item.Id = item.Id;
                    item.ProductName = item.Product2.Name;
                    item.Product2Id = item.Product2.Id;
                    item.ProductCode = item.Product2.ProductCode;
                    item.PricebookPrice = item.UnitPrice;

                    if(cont < 100)
                        rs.push(item);

                    cont++;
                });

                cmp.set('v.dataProdsToAdd', retorno);
                cmp.set('v.dataProdsToAddFiltered', rs);

                cmp.set('v.selectingPriceBook', false);
                cmp.set("v.isLoading", false);
            }else if (state === "ERROR") {
                this.showToast('error', 'Erro', 'Erro, contate o Tech.');
            }
        });
        $A.enqueueAction(action);
	},

    setProdsAddedValidatePricebook : function(cmp) {
        cmp.set("v.isLoading", true);
        var action = cmp.get('c.getAmostraLineItems');        
        action.setParams({id : cmp.get('v.amostraId')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var retorno =  response.getReturnValue();

                cmp.set('v.dataProdsAdded', retorno);
                this.validatePricebook(cmp);
            }else if (state === "ERROR") {
                this.showToast('error', 'Erro', 'Erro, contate o Tech.');
            }
        });
        $A.enqueueAction(action);
    },

    setItemValues : function (item, draft) {
        item.Quantity = draft.Quantity == undefined ? item.Quantity : draft.Quantity;
        item.UnitDiscountPrice = draft.UnitDiscountPrice == undefined ? item.UnitDiscountPrice : draft.UnitDiscountPrice;
        item.DiscountPercentage = draft.DiscountPercentage == undefined ? item.DiscountPercentage : draft.DiscountPercentage;
        item.DiscountPercentage = item.DiscountPercentage < 1 ? item.DiscountPercentage : (item.DiscountPercentage / 100);
        item.SuggestedPrice = draft.SuggestedPrice == undefined ? item.SuggestedPrice : draft.SuggestedPrice;

        if($A.util.isUndefinedOrNull(draft.DiscountPercentage))
            item.DiscountPercentage = (1 - (item.UnitDiscountPrice / item.PricebookPrice));

        else if($A.util.isUndefinedOrNull(draft.UnitDiscountPrice))
            item.UnitDiscountPrice = item.PricebookPrice - (item.DiscountPercentage * item.PricebookPrice);

        if(item.UnitDiscountPrice < 0) {
            this.showToast('error', 'Erro', 'Valor com desconto menor que zero.');
            item.UnitDiscountPrice = item.PricebookPrice;
            item.DiscountPercentage = 0;
        }

        if(item.UnitDiscountPrice > item.PricebookPrice) {
            this.showToast('error', 'Erro', 'Valor com desconto maior que valor da tabela.');
            item.UnitDiscountPrice = item.PricebookPrice;
            item.DiscountPercentage = 0;
        }

        if(item.Quantity < 1) {
            this.showToast('error', 'Erro', 'Quantidade menor que 1.');
            item.Quantity = 1;
        }

        if(item.DiscountPercentage > 1) {
            this.showToast('error', 'Erro', 'Desconto maior que 100%.');
            item.DiscountPercentage = 0;
            item.UnitDiscountPrice = item.PricebookPrice;
        }

        if(item.DiscountPercentage < 0) {
            this.showToast('error', 'Erro', 'Desconto menor que 0%.');
            item.DiscountPercentage = 0;
            item.UnitDiscountPrice = item.PricebookPrice;
        }

        if(item.SuggestedPrice < 0) {
            this.showToast('error', 'Erro', 'Preço sugerido menor que 0.');
            item.SuggestedPrice = item.PricebookPrice * 1.2;
        }

        item.TotalWithoutDiscountPrice = item.Quantity * item.PricebookPrice;
        item.TotalDiscountPrice = item.Quantity * item.UnitDiscountPrice;
        item.PotentialProfit = (item.SuggestedPrice * item.Quantity) - (item.UnitDiscountPrice * item.Quantity);


        return item;
    },

    showToast : function(tipo, titulo, erro) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": titulo,
            "message": erro,
            "type": tipo
        });
        toastEvent.fire();
    },

    validateQuantity : function(cmp) {
        const products = cmp.get('v.dataProdsAdded');
        let hasError = false;
        const checkIfHasQuantity = (product) => {
            if (product.Quantity == null)
                hasError = true;
        }
        products.forEach(checkIfHasQuantity);

        return hasError;
    },

})