@IsTest
public class ClienteRetornoTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"Status\": \"OK\",'+
		'    \"Data\": {'+
		'        \"Exports\": {'+
		'        },'+
		'        \"Tables\": ['+
		'            {'+
		'                \"Name\": \"E_DADOS\",'+
		'                \"Structures\": ['+
		'                    {'+
		'                        \"KUNNR\": \"0000068171\",'+
		'                        \"NAME1\": \"ESCOLA DE EDUCACAO INFANTIL PE\",'+
		'                        \"REGIO\": \"SP\",'+
		'                        \"CNPJ_CPF\": \"01853863000174\",'+
		'                        \"KNKLI\": \"0000068171\",'+
		'                        \"KLIMK\": \"14604,68\",'+
		'                        \"SKFOR\": \"2845,83\",'+
		'                        \"SALDO\": \"11758,85\",'+
		'                        \"CMGST\": \"B\",'+
		'                        \"TOTAL_AT\": \"6811,83\",'+
		'                        \"KTOKD\": \"\",'+
		'                        \"BUKRS\": \"\",'+
		'                        \"ANRED\": \"\",'+
		'                        \"SORTL\": \"\",'+
		'                        \"STRAS\": \"\",'+
		'                        \"ORT02\": \"\",'+
		'                        \"ORT01\": \"\",'+
		'                        \"PSTLZ\": \"\",'+
		'                        \"LAND1\": \"\",'+
		'                        \"SMTP_ADDR\": \"\",'+
		'                        \"LIFNR\": \"\",'+
		'                        \"STCD3\": \"\",'+
		'                        \"STCD4\": \"\",'+
		'                        \"XSUBT\": \"\",'+
		'                        \"VKORG\": \"\",'+
		'                        \"VTWEG\": \"\",'+
		'                        \"SPART\": \"\",'+
		'                        \"BZIRK\": \"\",'+
		'                        \"VKBUR\": \"\",'+
		'                        \"VKGRP\": \"\",'+
		'                        \"KDGRP\": \"\",'+
		'                        \"KALKS\": \"\",'+
		'                        \"VERSG\": \"\",'+
		'                        \"LPRIO\": \"00\",'+
		'                        \"VSBED\": \"\",'+
		'                        \"PERFK\": \"\",'+
		'                        \"PERRL\": \"\",'+
		'                        \"INCO1\": \"\",'+
		'                        \"INCO2\": \"\",'+
		'                        \"ZTERM\": \"Z007\",'+
		'                        \"KTGRD\": \"\",'+
		'                        \"TAXKD\": \"\",'+
		'                        \"CLSTR\": \"\"'+
		'                    }'+
		'                ]'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		ClienteRetorno obj = ClienteRetorno.parse(json);
		System.assert(obj != null);
	}
}