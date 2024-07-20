/*
*
* Teste da Class VTEX() - 21/11/2016
*
*/
@isTest
// @isTest(SeeAllData=true)
public class VTEX_INSTITUICAO_TESTE {
    static testMethod void Instituicao() {
        apexpages.currentpage().getparameters().put('keyID' ,'');
        VTEX.gerar_json_instituicao();
        
        apexpages.currentpage().getparameters().put('keyID' ,'67b24cd52a1c3ec11151240c163cd918');
        apexpages.currentpage().getparameters().put('uf' ,'SP');
        apexpages.currentpage().getparameters().put('cidade' ,'CAMPINAS');
        VTEX.gerar_json_instituicao();
        
        apexpages.currentpage().getparameters().put('linha' ,'U');
        VTEX.gerar_json_instituicao();
        
        VTEX vtx = new VTEX();
        VTEX.InstituicaoAtualizado vtxInst = new VTEX.InstituicaoAtualizado();
        vtxInst.ID = '0001';
        vtxInst.Nome = 'Nome';
    }   
}