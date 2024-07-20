@isTest
private class RecordTypeUtilTest 
{
	@isTest 
	static void getTest()
	{
		RecordTypeUtil.getInstance().getTodosRecordTypes('Account');
		RecordTypeUtil.getInstance().getRecordTypesPorNome('Account', new List<String>{'Universidades', 'Contatos'});
		RecordTypeUtil.getInstance().getRecordTypePorId('Account', '012d0000000hL8L');
		RecordTypeUtil.getInstance().getRecordTypePorNome('Account','School');
	}
}