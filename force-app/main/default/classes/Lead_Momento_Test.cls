@isTest
public class Lead_Momento_Test {
    @isTest static void lead_momento(){
        List<Lead> leads = new List<Lead>();
        List<String> st = new List<String>{ 'ebook-guia-definitivo-para-se-tornar-dono-de-franquias',
                'seja-um-franqueado-yazigi', 'ebook-8-maiores-diferenciais-das-franquias-de-educacao',
                'ebook-investir-em-franquias-de-sucesso', 'ebook-como-tornar-sua-franquia-de-idiomas-rentavel', 
                'ebook-franquia-de-idiomas-com-alta-lucratividade', 'live-aprendizagem-criativa-e-habilidades-do-seculo-xxi',
                'live-inovacao-e-transformacao-digital-nos-negocios', 'live-razoes-para-investir-em-uma-franquia-de-idiomas-de-sucesso',
                'encontro-de-negocios-online-1', 'ebook-investimento-na-crise', 'ebook-franquia-de-sucesso-erros-que-voce-nao-deve-cometer',
                'dados-cadastrais', 'live-por-que-sair-da-sua-zona-de-conforto-e-ser-empreendedor', 'contato-comercial-em-breve',
                'seja-um-franqueado-yazigi-fundo', 'ebook-franquias-de-sucesso-erros-que-voce-nao-deve-cometer-topo', 
                'ebook-como-tornar-sua-franquia-de-idiomas-rentavel-fundo', 'ebook-investimento-na-crise-meio',
                'ebook-investir-em-franquias-de-sucesso-topo', 'ebook-guia-definitivo-para-se-tornar-dono-de-franquias-topo', 'teste'};
                    
                    List<String> st2 = new List<String>{
                        'ebook-franquias-o-que-saber-para-investir-nesse-mercado',
                            'seja-um-franqueado-wizard-by-pearson', 'ebook-franquias-de-educacao', 'atualizacao-dados-cadastrais', 
                            'contato-comercial-em-breve', 'whatsapp-button', 'formulario-seja-um-franqueado-wizard-fundo', 
                            'formulario-site-wizard-ebook-franquias-de-educacao-topo', 'formulario-site-wizard-ebook-franquias-topo', 'teste'};
                                
                                List<String> st3 = new List<String>{
                                    'seja-um-licenciado-skilled', 'seja-um-parceiro-pearson', 'live-skill-ed-uma-nova-experiencia-de-aprendizagem',
                                        'condicao-especial', 'dados-cadastrais', 'ebook-estrategias-de-gestao-escolar-na-pratica',
                                        'whatsapp-button', 'formulario-ebook-lifelong-learning-topo', 'formulario-estrategias-de-gestao-escolar-na-pratica-topo', 'teste'};
                                            
                                            for(Integer i=0; i < st.size(); i++){
                                                Lead l = new Lead();
                                                l.Marca_RD_Station__c = 'Yázigi';
                                                l.Origem_da_ultima_conversao__c = st[i];
                                                leads.add(l);
                                            }
        
        for(Integer i=0; i < st2.size(); i++){
            Lead l = new Lead();
            l.Marca_RD_Station__c = 'Wizard';
            l.Origem_da_ultima_conversao__c = st2[i];
            leads.add(l);
        }
        
        for(Integer i=0; i < st3.size(); i++){
            Lead l = new Lead();
            l.Marca_RD_Station__c = 'Skill.Ed';
            l.Origem_da_ultima_conversao__c = st3[i];
            leads.add(l);
        }
        
        Lead l = new Lead();
        l.Marca_RD_Station__c = 'Teste';
        l.Origem_da_ultima_conversao__c = 'Teste';
        leads.add(l);
        
        Lead_Momento.DefineMomento(leads);
    }
    
}