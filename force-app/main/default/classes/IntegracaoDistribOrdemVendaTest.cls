public class IntegracaoDistribOrdemVendaTest implements IntegracaoDistribOrdemVendaInterface {

	public IntegracaoDistribOrdemVendaRetornoTO criar(IntegracaoDistribuicaoOrdemVendaTO integracaoDistribuicaoOrdemVendaTO)
    {
        IntegracaoDistribOrdemVendaRetornoTO to = new IntegracaoDistribOrdemVendaRetornoTO();
        to.status = 'OK';
        to.data = new IntegracaoDistribOrdemVendaRetornoTO.Data();
        to.data.Exports = new IntegracaoDistribOrdemVendaRetornoTO.Exports();
        to.data.Tables =  new List<IntegracaoDistribOrdemVendaRetornoTO.Table>();
        return to;
    }
}