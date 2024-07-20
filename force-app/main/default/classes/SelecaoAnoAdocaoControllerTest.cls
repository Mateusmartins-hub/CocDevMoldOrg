@isTest
private class SelecaoAnoAdocaoControllerTest {
	
	static testMethod void controllerTest2() 
	{
		PageReference pageRef = Page.SelecaoAnoAdocao;
        Test.setCurrentPage(pageRef);

		SelecaoAnoAdocaoController cls = new SelecaoAnoAdocaoController();

		cls.pesquisar();

		cls.anoSelecionado = '2014';
		cls.professorSelecionado = '';
		cls.salvar();

		cls.professorSelecionado = 'professor';
		cls.salvar();

		cls.cancelar();
	}
	
}