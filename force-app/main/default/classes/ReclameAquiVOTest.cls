@IsTest
public class ReclameAquiVOTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"data\": ['+
		'    {'+
		'      \"hugme_status\": {'+
		'        \"id\": 21,'+
		'        \"name\": \"Novo\"'+
		'      },'+
		'      \"ra_status\": {'+
		'        \"id\": 5,'+
		'        \"name\": \"Não respondido\"'+
		'      },'+
		'      \"favorable_assessment\": {'+
		'        \"id\": 0,'+
		'        \"description\": \"Não Solicitado\"'+
		'      },'+
		'      \"information_source\": {'+
		'        \"id\": 1,'+
		'        \"name\": \"RA Reclamação\"'+
		'      },'+
		'      \"source\": {'+
		'        \"id\": 1,'+
		'        \"name\": \"ReclameAQUI\"'+
		'      },'+
		'      \"company\": {'+
		'        \"id\": 620,'+
		'        \"name\": \"Yázigi\"'+
		'      },'+
		'      \"last_feeling\": {'+
		'        \"id\": -1'+
		'      },'+
		'      \"feed_type\": {'+
		'        \"id\": -1'+
		'      },'+
		'      \"moderation\": {'+
		'        \"user\": {'+
		'          \"id\": -1'+
		'        }'+
		'      },'+
		'      \"ra\": {'+
		'        \"replicas_count\": 0,'+
		'        \"source_id\": 1,'+
		'        \"source_name\": \"Site\",'+
		'        \"internal_process\": true,'+
		'        \"blackfriday\": false'+
		'      },'+
		'      \"customer\": {'+
		'        \"birthday\": [],'+
		'        \"cpf\": ['+
		'          \"08290480903\"'+
		'        ],'+
		'        \"rg\": [],'+
		'        \"gender\": ['+
		'          \"Masculino\"'+
		'        ],'+
		'        \"email\": ['+
		'          \"victor_bolzon@hotmail.com\"'+
		'        ],'+
		'        \"phone_numbers\": ['+
		'          \"43996848707\",'+
		'          \"43996848707\"'+
		'        ],'+
		'        \"photo\": [],'+
		'        \"id\": 51349142,'+
		'        \"duplicate_id\": 3913470,'+
		'        \"name\": \"Victor Bolzon\",'+
		'        \"city\": ['+
		'          {'+
		'            \"id\": 1693,'+
		'            \"name\": \"Arapongas\"'+
		'          }'+
		'        ],'+
		'        \"state\": ['+
		'          {'+
		'            \"id\": 18,'+
		'            \"name\": \"Paraná\",'+
		'            \"fs\": \"PR\"'+
		'          }'+
		'        ],'+
		'        \"tags\": [],'+
		'        \"pending_tickets_count\": 0'+
		'      },'+
		'      \"user\": {'+
		'        \"id\": -1'+
		'      },'+
		'      \"account\": {'+
		'        \"id\": -1'+
		'      },'+
		'      \"rafone\": {'+
		'        \"status_id\": -1'+
		'      },'+
		'      \"id\": 36570077,'+
		'      \"source_external_id\": \"109960167\",'+
		'      \"can_like\": false,'+
		'      \"commentary\": false,'+
		'      \"creation_date\": \"2020-08-07T15:16:43.000Z\",'+
		'      \"insertion_date\": \"2020-08-07T15:18:32.000Z\",'+
		'      \"complaint_title\": \"Teste 07082020\",'+
		'      \"filed\": false,'+
		'      \"last_modification_date\": \"2020-08-07T15:16:43.000Z\",'+
		'      \"request_moderation\": true,'+
		'      \"request_evaluation\": false,'+
		'      \"frozen\": false,'+
		'      \"complaint_content\": \"Teste 07082020\",'+
		'      \"ra_reason\": \"Outros\",'+
		'      \"interactions_count\": 1,'+
		'      \"interactions_not_readed_count\": 6,'+
		'      \"resolved_issue\": false,'+
		'      \"back_doing_business\": false,'+
		'      \"rating\": \"-1\",'+
		'      \"comments_count\": 0,'+
		'      \"redistributions_count\": 0,'+
		'      \"ticket_moderations_count\": 0,'+
		'      \"ticket_messages_count\": 0,'+
		'      \"rating_without_response\": false,'+
		'      \"customer_interactions_count\": 6,'+
		'      \"company_interactions_count\": 0,'+
		'      \"assignment_count\": 0,'+
		'      \"rule_id\": 2295,'+
		'      \"duplicate_ticket\": [],'+
		'      \"tags\": [],'+
		'      \"extra_data\": {},'+
		'      \"sticky_notes\": [],'+
		'      \"autos\": [],'+
		'      \"personalized_fields\": [],'+
		'      \"attached\": ['+
		'        {'+
		'          \"id\": \"286844353\",'+
		'          \"type_detail_id\": 15,'+
		'          \"name\": \"Anexo\",'+
		'          \"detail_description\": \"https://raichu-uploads.s3.amazonaws.com/complain_9b98b339-5630-4389-8da0-25a97816e166.jpg\",'+
		'          \"creation_date\": \"2020-08-07T15:16:43.000Z\",'+
		'          \"privacy\": false'+
		'        }'+
		'      ],'+
		'      \"categories\": [],'+
		'      \"historical\": ['+
		'        {'+
		'          \"user\": {'+
		'            \"id\": -1'+
		'          },'+
		'          \"auto\": {'+
		'            \"id\": -1'+
		'          },'+
		'          \"id\": 361540030,'+
		'          \"creation_date\": \"2020-08-07T15:18:34.000Z\"'+
		'        },'+
		'        {'+
		'          \"user\": {'+
		'            \"id\": -1'+
		'          },'+
		'          \"auto\": {'+
		'            \"id\": -1'+
		'          },'+
		'          \"id\": 361540031,'+
		'          \"creation_date\": \"2020-08-07T15:18:34.000Z\"'+
		'        }'+
		'      ],'+
		'      \"interactions\": ['+
		'        {'+
		'          \"ticket_interaction_id\": \"131353050\",'+
		'          \"ticket_interaction_type_id\": 1,'+
		'          \"ticket_interaction_name\": \"Manifestação\",'+
		'          \"customer_id\": \"51349142\",'+
		'          \"message\": \"Teste 07082020\",'+
		'          \"privacy\": false,'+
		'          \"creation_date\": \"2020-08-07T15:16:43.000Z\",'+
		'          \"delivered\": true,'+
		'          \"readed\": false,'+
		'          \"visualized\": false,'+
		'          \"details\": ['+
		'            {'+
		'              \"ticket_detail_id\": \"286844349\",'+
		'              \"ticket_detail_type_id\": 1,'+
		'              \"name\": \"Assunto\",'+
		'              \"value\": \"Outros\",'+
		'              \"creation_date\": \"2020-08-07T15:16:43.000Z\",'+
		'              \"privacy\": false'+
		'            },'+
		'            {'+
		'              \"ticket_detail_id\": \"286844350\",'+
		'              \"ticket_detail_type_id\": 14,'+
		'              \"name\": \"Assunto ID\",'+
		'              \"value\": \"27\",'+
		'              \"creation_date\": \"2020-08-07T15:16:43.000Z\",'+
		'              \"privacy\": false'+
		'            },'+
		'            {'+
		'              \"ticket_detail_id\": \"286844351\",'+
		'              \"ticket_detail_type_id\": 8,'+
		'              \"name\": \"IP\",'+
		'              \"value\": \"201.82.50.59\",'+
		'              \"creation_date\": \"2020-08-07T15:16:43.000Z\",'+
		'              \"privacy\": false'+
		'            },'+
		'            {'+
		'              \"ticket_detail_id\": \"286844352\",'+
		'              \"ticket_detail_type_id\": 3,'+
		'              \"name\": \"Contato 1\",'+
		'              \"value\": \"43996848707\",'+
		'              \"creation_date\": \"2020-08-07T15:16:43.000Z\",'+
		'              \"privacy\": false'+
		'            },'+
		'            {'+
		'              \"ticket_detail_id\": \"286844353\",'+
		'              \"ticket_detail_type_id\": 15,'+
		'              \"name\": \"Anexo\",'+
		'              \"value\": \"https://raichu-uploads.s3.amazonaws.com/complain_9b98b339-5630-4389-8da0-25a97816e166.jpg\",'+
		'              \"creation_date\": \"2020-08-07T15:16:43.000Z\",'+
		'              \"privacy\": false'+
		'            },'+
		'            {'+
		'              \"ticket_detail_id\": \"286916699\",'+
		'              \"ticket_detail_type_id\": 25,'+
		'              \"name\": \"ID Site RA\",'+
		'              \"value\": \"eTXmcr-ntcXKlvZ-\",'+
		'              \"creation_date\": \"2020-08-07T18:50:50.000Z\",'+
		'              \"privacy\": false'+
		'            }'+
		'          ]'+
		'        }'+
		'      ],'+
		'      \"active\": true,'+
		'      \"duplicate_tiqt\": []'+
		'    }'+
		'  ],'+
		'  \"meta\": {'+
		'    \"page\": {'+
		'      \"size\": 25'+
		'    },'+
		'    \"total\": 6105'+
		'  }'+
		'}';
		ReclameAquiVO obj = ReclameAquiVO.parse(json);
		System.assert(obj != null);
	}
    
    static testMethod void testParseResponseRespostaPublica() {
        String json = '{"message":"test", "success":true}';
        ReclameAquiVO.parseResponseRespostaPublica(json);
    }
    
    static testMethod void testRespostaRA() {
        ReclameAquiVO.RespostaRA resp = new ReclameAquiVO.RespostaRA();
        resp.id = 'test';
        resp.message = 'test';
        resp.reason = 'test';
        resp.ResponseRespostaPublica = new ReclameAquiVO.ResponseRespostaPublica();
    }
}