({

	handleCheckinCheckout: function (component, recordId) {
		$A.get("e.force:closeQuickAction").fire();
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
				const responseBody = JSON.parse(response.getReturnValue());
				component.set("v.isLoading", false);
				$A.get('e.force:refreshView').fire();

				if (responseBody.action == 'checkout') {
					const evt = $A.get("e.force:navigateToComponent");
					evt.setParams({
						componentDef  : "c:EventCheckOut",
						componentAttributes: {
							eventId : component.get("v.recordId")
						}
					});
					evt.fire();
				} else {
					component.set("v.checkinDone", true);
				}

//				if (!responseBody.hasResearch)
//					context.showToast('warning', 'Preenchimento de pesquisas', 'Nenhuma pesquisa foi preenchida para esse registro. Não se esqueça de preencher pelo menos uma das seguintes pesquisas: Nbr. of Teachers and Students, Institution fees, Índices de desempenho e avaliação');
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