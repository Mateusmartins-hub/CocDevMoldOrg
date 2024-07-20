public with sharing class pcdSendMailController {

	public List<Produtos_com_desconto__c> pcd{get;set;}
	public Contact ctt{get;set;}

	public pcdSendMailController(ApexPages.StandardController controller) {
		Id cttId = ApexPages.currentPage().getParameters().get('id');
		
		ctt = [Select Id, Name, Email From Contact Where Id=:cttId];
		
		pcd = [Select Autor__c, Titulo__r.Descricao_Concatenado__c
                From Produtos_com_desconto__c 
                where Professor__c = :cttId and Produto_Adquirido__c <> 'Sim'];
	}

	public PageReference send() {
		String Msg ='';
		String TempHTML = '';
		String listProd = '';
		String cttNome = (String)ctt.Name;
		String[] toAddresses = new String[]{(String)ctt.Email};
		
		if(ctt.Email ==Null){
			Msg+= 'Contato não possuí e-mail cadastrado. ';
		}
		
		if(pcd.size() == 0){
			Msg+='Não há produtos não adquiridos para ser enviado. ';	
		}
		
		if(Msg <> ''){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Msg);
 	      	ApexPages.addMessage(myMsg);
			return Null;
		}
		
		TempHTML = HTMLBoby();
		TempHTML = TempHTML.replace('#ReplaceContato#', cttNome);
		listProd = ListaProdutosHTML();
		TempHTML = TempHTML.replace('#ListaProdutos#', listProd);
		
		// Define the email
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

		// Sets the paramaters of the email
		email.setSubject('Produtos com Desconto');
		email.setToAddresses(toAddresses);
		email.setHtmlBody(TempHTML);
    
		// Sends the email
		Messaging.SendEmailResult [] r = 
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   

		return new PageReference('/' + ctt.Id);
	}
	
	public PageReference cancel() {
		return new PageReference('/' + ctt.Id);
	}
	
	private String HTMLBoby(){
		String HTML ='';
		
			HTML+= '<html>';
			HTML+= '<head>';
			HTML+= '<title>CRC On Line</title>';
			HTML+= '<style type="text/css">';
			HTML+= 'td{font-family:Arial,Verdana, Helvetica, sans-serif;font-size:14px;}';
			HTML+= '.assinatura{font-family:Verdana, Arial, Helvetica, sans-serif;font-size:14px;color:#003C77;}';
			HTML+= '</style>';
			HTML+= '</head>';
			HTML+= '<body>';
			HTML+= '<table width="659" border="0">';
			HTML+= '<tr><td><center>';
			HTML+= '<font color="#FF0000">-------------------------------- <strong>ATEN&Ccedil;&Atilde;O</strong> -----------------------------------</font><br></br>';
			HTML+= 'Esta &eacute; uma mensagem autom&aacute;tica, por favor n&atilde;o responda. <br></br>';
			HTML+= 'Retorno para <strong><font color="#FF0000">livrouniversitario@pearson.com</font></strong><br></br>';
			HTML+= '<font color="#FF0000">---------------------------------------------------------------------------------</font><br></br>';
			HTML+= '</center></td></tr>';
			HTML+= '<tr><td>Prezado(a)&nbsp; professor(a) : &#13; &#13; <strong>#ReplaceContato#</strong></td></tr>';
			HTML+= '<tr><td>&nbsp;</td></tr>';
			HTML+= '<tr><td><p>Devido &agrave; grande quantidade de solicita&ccedil;&otilde;es, nossa verba destinada ao envio de cortesias do(s) t&iacute;tulo(s) infelizmente est&aacute; esgotada, o que nos impede de atender a sua   solicita&ccedil;&atilde;o neste momento.</p></td></tr>';
			HTML+= '<tr><td>Entretanto, com o intuito de suprir sua necessidade, oferecemos como op&ccedil;&atilde;o a compra da(s)   obra(s) com o desconto especial de 75% sobre o pre&ccedil;o de capa mais o frete<font color="#FF0000" size="2" face="Arial, Helvetica, sans-erif">*</font>.<font color="#FF0000" size="2" face="Arial, Helvetica, sans-serif">&nbsp; </font> Os demais livros solicitados poderão  ser adquiridos com o desconto de 40%<font color="#FF0000" size="2" face="Arial, Helvetica, sans-if">*</font>.<br><br/></td></tr>';
			HTML+= '<tr><td><p>Obra(s) solicitada(s) com desconto especial de 75%:</p></td></tr>';
			HTML+= '<tr><td>#ListaProdutos#</td></tr>';
			HTML+= '<tr><td><p>O pagamento poder&aacute; ser realizado atrav&eacute;s de: </p>';
			HTML+= '<ul><li>Cart&atilde;o de cr&eacute;dito (Visa, Mastercard ou Diners)</li>';
			HTML+= '<li>Boleto banc&aacute;rio </li>';
			HTML+= '<li>D&eacute;bito em conta (Banco do Brasil) </li>';
			HTML+= '<li>Dep&oacute;sito identificado (Ita&uacute; ou Banco do Brasil)<br></br></li><p></p></ul></td></tr>';
			HTML+= '<tr><td> Caso tenha interesse em adquirir esta(s) obra(s), por gentileza, acesse o site  <a href="http://www.pearson.com.br/perfil_logar.asp?id_p=3" target="_blank">http://www.pearson.com.br/perfil_logar.asp?id_p=3l</a> e informe o seu CPF e email. </td></tr>';
			HTML+= '<tr><td><br></br><font color="#FF0000" size="2" face="Arial, Helvetica, sans-serif">*O valor do frete n&atilde;o est&aacute; incluso no desconto especial de 75% e 40%</font></td></tr>';
			HTML+= '<tr><td><p>Para   mais informa&ccedil;&otilde;es entre em contato pelo e-mail <a href="mailto:livrouniversitario@pearson.com">livrouniversitario@pearson.com</a>   ou ligue para (11) 2178-8662 de segunda a sexta, das 8h &agrave;s   18h.</p></td></tr>';
			HTML+= '<tr><td>&nbsp;</td></tr>';
			HTML+= '<tr><td>Estamos  &agrave; disposi&ccedil;&atilde;o para esclarecer eventuais d&uacute;vidas.</td></tr>';
			HTML+= '<tr><td>&nbsp;</td></tr>';
			HTML+= '<tr><td>Atenciosamente,&#13; </td></tr>';
			HTML+= '<tr><td>&nbsp;</td></tr>';
			HTML+= '<tr><td class="assinatura"><strong><em>Pearson Education</em></strong></td></tr>';
			HTML+= '<tr><td class="assinatura">&#13; <strong><em>Departamento de Marketing Universit&aacute;rio.</em></strong> &#13; &#13; </td></tr>';
			HTML+= '</table></body></html>';
	
		return HTML;
	}
	
	private String ListaProdutosHTML(){
		String listaProd = '';
		Integer i;
		
		listaProd+='<table width="568" border="0" align="center">';
		listaProd+= '<tr><td bgcolor="#0099CC"></td></tr>';
		
		for (i = 0; i < pcd.size(); i++) {
    		listaProd+='<tr><td>&#13;' + (String)pcd[i].Autor__c + ', ' + (String)pcd[i].Titulo__r.Descricao_Concatenado__c + '</td></tr>';
    		listaProd+='<tr><td bgcolor="#0099CC"></td></tr>';
		}
		
		listaProd+='</table>';
		
		return listaProd;
	}
}