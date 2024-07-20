({
	/**
	 * Map of pre-chat field label to pre-chat field name (can be found in Setup)
	 */
	fieldLabelToName: {
        'Primeiro Nome': 'FirstName',
        'Sobrenome': 'LastName',
        'Assunto': 'Subject',
        'First Name': 'FirstName',
        'Last Name': 'LastName',
        'Email': 'Email',
        'Phone': 'Phone',
        'Fax': 'Fax',
        'Mobile': 'MobilePhone',
        'Home Phone': 'HomePhone',
        'Other Phone': 'OtherPhone',
        'Asst. Phone': 'AssistantPhone',
        'Title': 'Title',
        'Lead Source': 'LeadSource',
        'Assistant': 'AssistantName',
        'Department': 'Department',
        'Subject': 'Subject',
        'Case Reason': 'Reason',
        'Type': 'Type',
        'Web Company': 'SuppliedCompany',
        'Web Phone': 'SuppliedPhone',
        'Priority': 'Priority',
        'Web Name': 'SuppliedName',
        'Web Email': 'SuppliedEmail',
        'Company': 'Company',
        'Industry': 'Industry',
        'Rating': 'Rating',
        'Descrição':'DescricaoChat__c' 
    },
    
    getUser : function(component, event, helper) {
		var action = component.get("c.getUser");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                this.getPreChatFields(component, event, helper);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    getPreChatFields: function(cmp, evt, hlp) {       
        // Get pre-chat fields defined in setup using the prechatAPI component
		var prechatFields = cmp.find("prechatAPI").getPrechatFields();
        console.log(prechatFields);
        
        // Get pre-chat field types and attributes to be rendered
        var prechatFieldComponentsArray = hlp.getPrechatFieldAttributesArray(cmp, prechatFields);
        console.log(prechatFieldComponentsArray);
        
        // Make asynchronous Aura call to create pre-chat field components
        $A.createComponents(
            prechatFieldComponentsArray,
            function(components, status, errorMessage) {
                if(status === "SUCCESS") {
                    cmp.set("v.prechatFieldComponents", components);
                }
                console.log(components);
            }
        );
    },
    
    
	/**
	 * Event which fires the function to start a chat request (by accessing the chat API component)
	 *
	 * @param cmp - The component for this state.
	 */
	onStartButtonClick: function(cmp) {
		var prechatFieldComponents = cmp.find('prechatField');
		var fields;

        // Make an array of field objects for the library
        fields = this.createFieldsArray(prechatFieldComponents);
        console.log(fields);
        
        // If the pre-chat fields pass validation, start a chat
        //if(cmp.find('prechatAPI').validateFields(fields).valid) {
            cmp.find('prechatAPI').startChat(fields);
        //} else {
            //console.warn('Prechat fields did not pass validation!');
        //}
	},

	/**
	 * Create an array of field objects to start a chat from an array of pre-chat fields
	 * 
	 * @param fields - Array of pre-chat field Objects.
	 * @returns An array of field objects.
	 */
	createFieldsArray: function(fields) {
		if(fields.length) {
			return fields.map(function(fieldCmp) {
                console.log(JSON.parse(JSON.stringify(fieldCmp)));
				return {
					label: fieldCmp.get('v.label'),
					value: fieldCmp.get('v.value'),
					name: this.fieldLabelToName[fieldCmp.get('v.label')]
				};
			}.bind(this));
		} else {
			return [];
		}
	},
    
    /**
     * Create an array in the format $A.createComponents expects
     * 
     * Example:
     * [['componentType', {attributeName: 'attributeValue', ...}]]
     * 
	 * @param prechatFields - Array of pre-chat field Objects.
	 * @returns Array that can be passed to $A.createComponents
     */
    getPrechatFieldAttributesArray: function(cmp, prechatFields) {
        var firstName =  cmp.get('v.userInfo.FirstName');
        var lastName =  cmp.get('v.userInfo.LastName');       
        var email =  cmp.get('v.userInfo.Email');       
        console.log(firstName);
        console.log(lastName); 
        console.log(email); 
        
        // $A.createComponents first parameter is an array of arrays. Each array contains the type of component being created, and an Object defining the attributes.
        var prechatFieldsInfoArray = [];

        // For each field, prepare the type and attributes to pass to $A.createComponents
        prechatFields.forEach(function(field) {
            
            var componentName = (field.type === 'inputSplitName') ? 'inputText' : field.type;
            var componentValue = (field.name === 'FirstName') ? firstName : (field.name === 'LastName') ? lastName :  (field.name === 'Email') ? email : field.value;
            var componentReadOnly = (field.name === 'FirstName' || field.name === 'LastName' || field.name === 'Email' ) ? true : field.readOnly;
            var componentInfoArray = ['ui:' + componentName];
            var attributes = {
                'aura:id': 'prechatField',
                required: field.required,
                label: field.label,
                disabled: componentReadOnly,
                maxlength: field.maxLength,
                class: field.className,
                value: componentValue
            };
            
            // Special handling for options for an input:select (picklist) component
            if(field.type === 'inputSelect' && field.picklistOptions) attributes.options = field.picklistOptions;
            
            // Append the attributes Object containing the required attributes to render this pre-chat field
            componentInfoArray.push(attributes);
            
            // Append this componentInfoArray to the fieldAttributesArray
            prechatFieldsInfoArray.push(componentInfoArray);
        });

        return prechatFieldsInfoArray;
    }
});