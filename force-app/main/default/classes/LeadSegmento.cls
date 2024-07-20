public with sharing class LeadSegmento {
       public static void validateQuantidadeAluno(List<Lead> leads) {

            
        for(Lead l : leads) {

            if(String.isNotBlank(l.Segmento__c)) {
                String[] segmentos = l.Segmento__c.split(';');
                


               for(String segmento : segmentos) {
                    if(segmento.equals('EI')) {
                        if(l.QuantidadeAlunosInfantil__c == null || l.QuantidadeAlunosInfantil__c == 0 ) {
                            l.QuantidadeAlunosInfantil__c.addError('Preencha o valor do campo \'Quantidade de Alunos Infantil\' ou remova o valor \'EI\' do campo Segmento ');
                        }
                    }
                    if(segmento.equals('EF1')) {
                        if(l.QuantidadeAlunosFundamental1__c == null || l.QuantidadeAlunosFundamental1__c == 0) {
                            l.QuantidadeAlunosFundamental1__c.addError('Preencha o valor do campo \'Quantidade de Alunos Fundamental I\' ou remova o valor \'EF1\' do campo Segmento');
                        }
                    } 

                    if(segmento.equals('EF2')) {
                        if(l.QuantidadeAlunosFundamental2__c == null || l.QuantidadeAlunosFundamental2__c == 0 ) {
                            l.QuantidadeAlunosFundamental2__c.addError('Preencha o valor do campo \'Quantidade de Alunos Fundamental II\' ou remova o valor \'EF2\' do campo Segmento ');
                        }
                    } 

                    if(segmento.equals('EM')) {
                        if(l.Quantidade_Alunos_Ensino_M_dio__c == null || l.Quantidade_Alunos_Ensino_M_dio__c == 0) {
                            l.Quantidade_Alunos_Ensino_M_dio__c.addError('Preencha o valor do campo \'Quantidade de Alunos Ensino Médio\' ou remova o valor \'EM\' do campo Segmento ');
                        }
                    } 

                    if(segmento.equals('PV')) {
                        if(l.Quantidade_Alunos_Pr_Vestibular__c == null || l.Quantidade_Alunos_Pr_Vestibular__c == 0) {
                            l.Quantidade_Alunos_Pr_Vestibular__c.addError('Preencha o valor do campo \'Quantidade de Alunos Pré Vestibular\' ou remova o valor \'PV\' do campo Segmento ');
                        }
                    } 

                }
                
            }

        }
    }

}