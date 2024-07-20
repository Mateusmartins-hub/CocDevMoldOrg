public class IntegracaoDistribOrdemVendaRetornoTO {

	public String status { get; set; } //Status de sucesso/falha da integração.
	public Data data { get; set; }

	public class Data{
		public Exports Exports { get; set; }
		public List<Table> Tables { get; set; }
	}

	public class Exports{
		public String MENSAGEM { get; set; }
		public String TRANSPORTADORA { get; set; }
		public String VBELN { get; set; }
	}

	public class Table{
		public String Name { get; set; }
		public List<Structures> Structures { get; set; }
	}

	public class Structures{

	}
}