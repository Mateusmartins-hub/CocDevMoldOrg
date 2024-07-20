({
	getEvents: function (component) {
		const action = component.get("c.getUserEvents");
		action.setCallback(this, function (response) {
			const state = response.getState();
			if (state === "SUCCESS") {
				const events = response.getReturnValue();
				this.handleEvents(component, events);
			}
		});
		$A.enqueueAction(action);
	},

	handleEvents: function (component, events) {
		const eventsWithUrl = events.map((event) => {
			event = this.createUrlToRecord(event, 'WhoId');
			event = this.createUrlToRecord(event, 'Id');
			return event;
		});
		component.set("v.userEvents", eventsWithUrl);
	},

	createUrlToRecord: function (event, field) {
		let newEvent = event;
		if (newEvent[field] != undefined)
			newEvent[field + 'URL'] = '/one/one.app?#/sObject/' + newEvent[field] + '/view';
		else
			newEvent[field] = undefined;
		return newEvent;
	},

	setColumns: function (component) {
		component.set('v.columnEvents', [
			{ label: 'Assunto', fieldName: 'Subject', type: 'text' },
			{ label: 'Data/Horário', fieldName: 'StartDateTime', type: 'date', typeAttributes: { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true } },
			{ label: 'Contato', fieldName: 'WhoIdURL', type: 'url', typeAttributes: { label: { fieldName: 'WhoName' } } },
			{ label: 'Compromisso', fieldName: 'IdURL', type: 'url', typeAttributes: { label: 'Ver compromisso' } },
			{ label: 'Visita realizada?', fieldName: 'VisitaRealizada', type: 'boolean' },
			 { label: '', type: 'button', initialWidth: 200, typeAttributes: { label: 'Check-in/Check-out', title: '', name: 'checkin' } }			
		]);
	},

	handleCheckinCheckout: function (component, recordId) {
		component.set('v.recordId', recordId);		
		this.getLocation(component, this.makeCheckinCheckout);		
	},

	getLocation: function (component, callback) {
		const successCallback = (pos) => {
			callback(pos, component, this);
		};

		const errorCallback = (err) => {
			this.showToast('error', 'Erro ao pegar localização', 'Ocorreu algum erro ao tentar encontrar sua localização, contate o tech.');
		};

		const positionOptions = {
			enableHighAccuracy: true
		};

		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(successCallback, errorCallback, positionOptions);
		} else {
			this.showToast('error', 'Localização não suportada', 'O browser atual não suporta localização');
		}
	},

	makeCheckinCheckout: function (position, component, context) {
		component.set("v.isLoading", true);
		const action = component.get("c.handleCheckinCheckout");
		action.setParams({
			recordId: component.get('v.recordId'),
			lat: position.coords.latitude,
			lon: position.coords.longitude
		});
		action.setCallback(context, function (response) {
			const state = response.getState();
			if (state === "SUCCESS") {
				const hasResearch = response.getReturnValue();
				component.set("v.isLoading", false);
				$A.get('e.force:refreshView').fire();
				context.showToast('success', 'Check-in/Check-out realizado com sucesso', 'O Check-in/Check-out foi realizado com sucesso');

				if (!hasResearch)
					context.showToast('warning', 'Preenchimento de pesquisas', 'Nenhuma pesquisa foi preenchida para esse registro. Não se esqueça de preencher pelo menos uma das seguintes pesquisas: Nbr. of Teachers and Students, Institution fees, Índices de desempenho e avaliação');
			} else {
				component.set("v.isLoading", false);
				context.showToast('error', 'Erro ao fazer check-in/check-out', 'Ocorreu algum erro na tentativa de check-in, contate o tech.');
			}
		});
		$A.enqueueAction(action);
	},

	showToast: function (type, title, error) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"message": error,
			"type": type
		});
		toastEvent.fire();
	}
})