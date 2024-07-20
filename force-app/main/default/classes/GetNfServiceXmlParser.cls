public class GetNfServiceXmlParser {
	/* 
	public String xml;
	
	public GetNfServiceXmlParser( String xml ){
		
		this.xml = xml;
		
		if ( xml.indexOf( '<![CDATA[<?xml version="1.0" encoding="utf-8"?>' )  != -1 )
			xml = xml.replace('<![CDATA[<?xml version="1.0" encoding="utf-8"?>','');
		
		if ( xml.indexOf( ']]>' )  != -1 )
			xml = xml.replace(']]>','');
	}
	
	public GetNfServiceResponse parse(){
	 	
	 	Dom.Document docx = new Dom.Document();
     	
     	docx.load( this.xml );
		
		Dom.XmlNode rootNode = docx.getRootElement();
		
		GetNfServiceResponse response = new GetNfServiceResponse();
		
		response.cabecalho = new CabecalhoGetNfServiceResponse();
		response.item = new List<ItemGetNfServiceResponse>();
		
		ItemGetNfServiceResponse item = null;
		
		for ( Dom.XmlNode childNode : rootNode.getChildElements() ){
			
			if ( childNode.getName() == 'Cabecalho'){
			
				for ( Dom.XmlNode valueNode : childNode.getChildElements() ){
									
					if ( valueNode.getName() == 'SalesId' )	
						response.cabecalho.salesId = valueNode.getText();
					
					if ( valueNode.getName() == 'Transportadora' )	
						response.cabecalho.transportadora = valueNode.getText();
					
					if ( valueNode.getName() == 'TipoDocFiscal' )	
						response.cabecalho.tipoDocFiscal = valueNode.getText();
					
					if ( valueNode.getName() == 'TipoOper' )	
						response.cabecalho.tipoOrder = valueNode.getText();
					
					if ( valueNode.getName() == 'MetodoPagto' )	
						response.cabecalho.metodoPagamento = valueNode.getText();
					
					if ( valueNode.getName() == 'CondPagto' )	
						response.cabecalho.condPagamento = valueNode.getText();
					
					if ( valueNode.getName() == 'TipoTitulo' )	
						response.cabecalho.tipoTitulo = valueNode.getText();
					
					if ( valueNode.getName() == 'NomeEmpresa' )	
						response.cabecalho.nomeEmpresa = valueNode.getText();	
					
					if ( valueNode.getName() == 'CNPJ' )	
						response.cabecalho.cnpj = valueNode.getText();
					
					if ( valueNode.getName() == 'InscEstadual' )	
						response.cabecalho.inscEstadual = valueNode.getText();
					
					if ( valueNode.getName() == 'Endereco' )	
						response.cabecalho.endereco = valueNode.getText();
	
				}
			}
				
			if ( childNode.getName() == 'Item'){
				
				item = new ItemGetNfServiceResponse();
					
				for ( Dom.XmlNode valueNode : childNode.getChildElements() ){	
				
					if ( valueNode.getName() == 'CodigoItem')	
						item.codigoItem = valueNode.getText();
					
					if ( valueNode.getName() == 'Descricao' )	
						item.descricao = valueNode.getText();
					
					if ( valueNode.getName() == 'Qtde' ){	
						item.quantidade = Integer.valueOf( valueNode.getText() );
						item.quantidadeInformada = 0;
					}
					if ( valueNode.getName() == 'Valor' )	
						item.valor = Decimal.valueOf( valueNode.getText() );
					
					if ( valueNode.getName() == 'BaseICMS' ){
						String text = ( valueNode.getText().indexOf('.')!=-1 ? valueNode.getText().replace('.','') : valueNode.getText() );	
						text = ( text.indexOf(',')!=-1 ? text.replace(',','.') : text );
						item.baseIcms = Decimal.valueOf( text );
					}
					if ( valueNode.getName() == 'PercentICMS' ){	
						String text = ( valueNode.getText().indexOf('.')!=-1 ? valueNode.getText().replace('.','') : valueNode.getText() );	
						text = ( text.indexOf(',')!=-1 ? text.replace(',','.') : text );
						item.percentIcms = Decimal.valueOf( text );
					}
					if ( valueNode.getName() == 'PercentIPI' ){	
						String text = ( valueNode.getText().indexOf('.')!=-1 ? valueNode.getText().replace('.','') : valueNode.getText() );	
						text = ( text.indexOf(',')!=-1 ? text.replace(',','.') : text );
						item.percentIpi = Decimal.valueOf( text );
					}
					
				}
				
				response.item.add( item );
			}
			
			
		}
		
		System.debug ( response );
		
		return response;
	
	
	
	}
	*/

}