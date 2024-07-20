public class ClienteRetorno {

	public class Tables {
		public String Name;
		public List<Structures> Structures;
	}

	public class Structures {
		public String KUNNR;
		public String NAME1;
		public String REGIO;
		public String CNPJ_CPF;
		public String KNKLI;
		public String KLIMK;
		public String SKFOR;
		public String SALDO;
		public String CMGST;
		public String TOTAL_AT;
		public String KTOKD;
		public String BUKRS;
		public String ANRED;
		public String SORTL;
		public String STRAS;
		public String ORT02;
		public String ORT01;
		public String PSTLZ;
		public String LAND1;
		public String SMTP_ADDR;
		public String LIFNR;
		public String STCD3;
		public String STCD4;
		public String XSUBT;
		public String VKORG;
		public String VTWEG;
		public String SPART;
		public String BZIRK;
		public String VKBUR;
		public String VKGRP;
		public String KDGRP;
		public String KALKS;
		public String VERSG;
		public String LPRIO;
		public String VSBED;
		public String PERFK;
		public String PERRL;
		public String INCO1;
		public String INCO2;
		public String ZTERM;
		public String KTGRD;
		public String TAXKD;
		public String CLSTR;
	}

	public class Data {
		public Exports Exports;
		public List<Tables> Tables;
	}

	public String Status;
	public Data Data;

	public class Exports {
	}
	
	public static ClienteRetorno parse(String json) {
		return (ClienteRetorno) System.JSON.deserialize(json, ClienteRetorno.class);
	}
}