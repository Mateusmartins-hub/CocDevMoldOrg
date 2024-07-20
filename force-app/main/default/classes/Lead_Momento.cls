public class Lead_Momento {

    /**
     * Define o valor do campo momento do Lead de acordo com 
     * os campos Marca RD Station x Origem da Ultima conversão. 
     */
    public static void DefineMomento(List<Lead> leads){

        for(Lead l : leads) { 
            if (string.isNotBlank(l.Marca_RD_Station__c) &&
                string.isNotBlank(l.Origem_da_ultima_conversao__c) ){

                if (l.Marca_RD_Station__c == 'Yázigi') {

                    switch on l.Origem_da_ultima_conversao__c {
                        when 'ebook-guia-definitivo-para-se-tornar-dono-de-franquias' {
                            l.MomentoLead__c = 'Topo';        
                        }
                        when 'seja-um-franqueado-yazigi' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'ebook-8-maiores-diferenciais-das-franquias-de-educacao' {
                            l.MomentoLead__c = 'Meio';
                        }
                        when 'ebook-investir-em-franquias-de-sucesso' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'ebook-como-tornar-sua-franquia-de-idiomas-rentavel' {
                            l.MomentoLead__c = 'Fundo';
                        }
                        when 'ebook-franquia-de-idiomas-com-alta-lucratividade' {
                            l.MomentoLead__c = 'Meio';
                        }
                        when 'live-aprendizagem-criativa-e-habilidades-do-seculo-xxi' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'live-inovacao-e-transformacao-digital-nos-negocios'{
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'live-razoes-para-investir-em-uma-franquia-de-idiomas-de-sucesso'{
                            l.MomentoLead__c = 'Fundo';
                        }
                        when 'encontro-de-negocios-online-1' {
                            l.MomentoLead__c = 'Meio';
                        }
                        when 'ebook-investimento-na-crise' {
                            l.MomentoLead__c = 'Meio';
                        }
                        when 'ebook-franquia-de-sucesso-erros-que-voce-nao-deve-cometer' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'dados-cadastrais' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'live-por-que-sair-da-sua-zona-de-conforto-e-ser-empreendedor' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'contato-comercial-em-breve' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'seja-um-franqueado-yazigi-fundo' {
                            l.MomentoLead__c = 'Levantada a mão';
                        }
                        when 'ebook-franquias-de-sucesso-erros-que-voce-nao-deve-cometer-topo' {
                            l.MomentoLead__C = 'Topo';
                        }
                        when 'ebook-como-tornar-sua-franquia-de-idiomas-rentavel-fundo' {
                            l.MomentoLead__c = 'Fundo';
                        }
                        when 'ebook-investimento-na-crise-meio' {
                            l.MomentoLead__c = 'Meio';
                        }
                        when 'ebook-investir-em-franquias-de-sucesso-topo' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'ebook-guia-definitivo-para-se-tornar-dono-de-franquias-topo' {
                            l.MomentoLead__c = 'Topo';
                        }
                        
                        when else {
                            l.MomentoLead__c = '';
                        }
                    }

                } else if (l.Marca_RD_Station__c == 'Wizard') { 

                    switch on l.Origem_da_ultima_conversao__c {
                        when 'ebook-franquias-o-que-saber-para-investir-nesse-mercado' {
                            l.MomentoLead__c = 'Topo';        
                        }
                        when 'seja-um-franqueado-wizard-by-pearson' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'ebook-franquias-de-educacao' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'atualizacao-dados-cadastrais' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'contato-comercial-em-breve' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'whatsapp-button' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'formulario-seja-um-franqueado-wizard-fundo' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'formulario-site-wizard-ebook-franquias-de-educacao-topo' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'formulario-site-wizard-ebook-franquias-topo' {
                            l.MomentoLead__c = 'Topo';
                        }
                        
                        when else {
                            l.MomentoLead__c = '';
                        }
                    }

                } else if (l.Marca_RD_Station__c == 'Skill.Ed') {

                    switch on l.Origem_da_ultima_conversao__c {
                        when 'seja-um-licenciado-skilled' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'seja-um-parceiro-pearson' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'live-skill-ed-uma-nova-experiencia-de-aprendizagem' {
                            l.MomentoLead__c = 'Fundo';
                        }
                        when 'condicao-especial' {
                            l.MomentoLead__c = 'Fundo';
                        }
                        when 'dados-cadastrais' {
                            l.MomentoLead__c = 'Levantada de mão';
                        }
                        when 'ebook-estrategias-de-gestao-escolar-na-pratica' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'whatsapp-button' {
                            l.MomentoLead__c = 'Levantada de mão'; 
                        }
                        when 'formulario-ebook-lifelong-learning-topo' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when 'formulario-estrategias-de-gestao-escolar-na-pratica-topo' {
                            l.MomentoLead__c = 'Topo';
                        }
                        when else {
                            l.MomentoLead__c = '';
                        }
                    }

                } else {
                    l.MomentoLead__c = '';
                }

            }

        }
    }
}