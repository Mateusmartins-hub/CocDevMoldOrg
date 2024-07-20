public class SimuladorComercialReportController {
	private Id oppId;
	public Simulador_Comercial__c[] itemSimulador {get;set;}
	public Opportunity[] opp {get;set;}
	public List<ErrorMessage> ErroMsg = new List<ErrorMessage>();
	
	public SimuladorComercialReportController(ApexPages.StandardController controller){
		List< String > lstOpp = new List< String >();
		
		oppId = ApexPages.currentPage().getParameters().get('id');
		itemSimulador = SimuladorComercialDAO.getInstance().getItensByOppId(oppId);
		
		lstOpp.add(oppId);
		opp = OpportunityDAO.getListOppById(lstOpp);
	}
	
	public String getTipoReport(){
		String retorno;
		Pricebook2 pb = new Pricebook2();
		
		pb = PricebookDAO.getInstance().getPricebookById(opp[0].Pricebook2Id);
		
		if (pb.Name.contains('COC')){
			retorno = 'COC';
		}else if(pb.Name.contains('Pueri Domus')){
			retorno = 'PD';
		}else if(pb.Name.contains('Dom Bosco')){
			retorno = 'DB';
		}else{
			retorno = '';
		}
		return retorno;
	}
	
	public List<Data> getDesconto(){
		
		List<Data> data = new List<Data>();
		List<String> lstDesconto = new List<String>();
		
		Decimal desc1;
		Decimal desc2;
		Decimal desc3;
		Decimal desc4;
		Decimal desc5;
		Integer vigencia;
		Integer anoInicio ;
		
		for(Opportunity lstOpp : opp){
			
			desc1 = lstOpp.BR_Desconto_1_ano__c;
			desc2 = lstOpp.BR_Desconto_2_ano__c;
			desc3 = lstOpp.BR_Desconto_3_ano__c;
			desc4 = lstOpp.BR_Desconto_4_ano__c;
			desc5 = lstOpp.BR_Desconto_5_ano__c;
			
			If(lstOpp.BR_Ano_Inicio_do_contrato__c <> Null){
				anoInicio = integer.valueOf(lstOpp.BR_Ano_Inicio_do_contrato__c);	
			}

			If(lstOpp.BR_Vigencia_do_contrato_anos__c <> Null){
				vigencia = integer.valueOf(lstOpp.BR_Vigencia_do_contrato_anos__c);	
			}
		}

		for(Integer i = 0; i < vigencia; i++){
			
			if(i==0){
				if(desc1 > 0){
					data.add(new Data(anoInicio + i,desc1));	
				}
			}else if(i==1){
				if(desc2 > 0){
					data.add(new Data(anoInicio + i,desc2));	
				}
			}else if(i==2){
				if(desc3 > 0){
					data.add(new Data(anoInicio + i,desc3));	
				}
			}else if(i==3){
				if(desc4 > 0){
					data.add(new Data(anoInicio + i,desc4));
				}
			}else if(i==4){
				if(desc5 > 0){
					data.add(new Data(anoInicio + i,desc5));
				}
			}
		}
		return data;
	}
	
	public List<ErrorMessage> getErroMsg(){
		for(Opportunity lstOpp : opp){
			if(lstOpp.BR_Imprimir_Proposta_Comercial_K12__c == false){
				ErroMsg.add(new ErrorMessage('Impressão da proposta comercial não aprovada.','A impressão da proposta comercial não foi aprovada, por favor solicite a aprovação antes de prosseguir.'));
			}
			If(lstOpp.BR_Ano_Inicio_do_contrato__c == Null){
				ErroMsg.add(new ErrorMessage('Ano Início do Contrato Inválido.','Ano de início de contrato inválido, por favor informe-o antes de imprimir a proposta comercial.'));
			}

			If(lstOpp.BR_Vigencia_do_contrato_anos__c == Null){
				ErroMsg.add(new ErrorMessage('Vigência do Contrato Inválido.','Vigência de contrato inválido, por favor informe-o antes de imprimir a proposta comercial.'));
			}
		}
		return ErroMsg;
	}
	
	public class Data {
		public Integer ano { get; set; }
        public Decimal desconto { get; set; }
        public Data(Integer ano, Decimal desconto) {
            this.ano = ano;
            this.desconto = desconto;
        }
	}
	
	public class ErrorMessage{
		public String Erro {get;set;}
		public String Descricao {get;set;}
		public ErrorMessage(String Erro, String Descricao){
			this.Erro = Erro;
			this.Descricao = Descricao;
		}
	}
}