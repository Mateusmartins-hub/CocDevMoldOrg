({
    doInit : function(cmp, event, helper) {
        helper.setColumns(cmp);
        helper.setAmostraId(cmp);        
    },
    
    setData : function(cmp, event, helper) {
        helper.setData(cmp);
    },
    
    filter: function(cmp, event, helper) {
        try{
            var prodsAdded = cmp.get('v.dataProdsAdded'),
                data = cmp.get("v.dataProdsToAdd"),
                term = cmp.get("v.search"),
                results = data, 
                regex;
            
            if(term.length >= 6) {
                regex = new RegExp(term, "i");
                results = data.filter(row => regex.test(row.ProductName));
                let cont = 0;
                var rs = [];
                
                results.forEach(function(item) {
                    if(cont < 100)
                        rs.push(item);
                    else
                        return false;
                    
                    cont++;
                });
                
                cont = 0;
                rs.forEach(function(item) {
                    var contem = false;
                    
                    prodsAdded.forEach(function(added) {
                        if(added.ProductName == item.ProductName)
                            contem = true;
                    });
                    
                    if(contem) {
                        if(cont == 0)
                            rs.shift();
                        else
                            rs.splice(cont, 1);
                    }
                    
                    cont++;
                });
                
                cmp.set('v.dataProdsToAddFiltered', rs);
            }else if(term.length == 0){
                var rs = [];
                var cont = 0;
                results.forEach(function(item) {
                    if(cont < 100)
                        rs.push(item);
                    else
                        return false;
                    
                    cont++;
                });
                
                cont = 0;
                rs.forEach(function(item) {
                    var contem = false;
                    
                    prodsAdded.forEach(function(added) {
                        if(added.ProductName == item.ProductName)
                            contem = true;
                    });
                    
                    if(contem) {
                        if(cont == 0)
                            rs.shift();
                        else
                            rs.splice(cont, 1);
                    }
                    
                    cont++;
                });
                
                cmp.set('v.dataProdsToAddFiltered', rs);
            }
        } catch(e){
            
        }
    },
    
    removeProd : function(cmp, event, helper) {
        var prodsToAdd = cmp.get("v.dataProdsToAdd");
        var prodsToAddFiltered = cmp.get('v.dataProdsToAddFiltered');
        var prodsAdded = cmp.get('v.dataProdsAdded');
        var item = event.getParam('row');
        var rowIndex = prodsAdded.indexOf(item);
        item.Id = item.PricebookEntryId;
        
        prodsAdded.splice(rowIndex, 1);
        cmp.set('v.dataProdsAdded', prodsAdded);
    },
    
    updateProdsAdded : function(cmp, event, helper) {
        var prodsAdded = cmp.get('v.dataProdsAdded');
        var item = event.getParam('row');
        item.DiscountPercentage = 0;
        item.PricebookEntryId = item.Id;
        item.Id = item.ProductName;
        item.UnitDiscountPrice = item.PricebookPrice;
        item.SuggestedPrice = item.PricebookPrice * 1.2;
        
        prodsAdded.push(item);
        cmp.set('v.dataProdsAdded', prodsAdded);
        
        var prodsToAddFiltered = cmp.get('v.dataProdsToAddFiltered');
        var rowIndex = prodsToAddFiltered.indexOf(item);
        
        prodsToAddFiltered.splice(rowIndex, 1);
        cmp.set('v.dataProdsToAddFiltered', prodsToAddFiltered);
    },
    
    handleSaveEdition : function(cmp, event, helper) {
        helper.savePricebook2IdAndItems(cmp);
    },
    
    cancelar : function(cmp, event, helper) {
        $A.get('e.force:closeQuickAction').fire();
    },
    
    handleEditCellChange : function (cmp, event, helper) {
        let draft = event.getParam('draftValues')[0];
        let dataProdsAdded = cmp.get('v.dataProdsAdded');
        dataProdsAdded.forEach(function(item) {
            if(item.Id == draft.Id) {
                item = helper.setItemValues(item, draft);    
                cmp.set('v.dataProdsAddedDraft', []);        
            }
        });
        cmp.set('v.dataProdsAdded', dataProdsAdded);
    },
})