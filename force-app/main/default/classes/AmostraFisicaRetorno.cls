public class AmostraFisicaRetorno {
        
    public String Status {get;set;} 
    public Data Data {get;set;} 
    
    public AmostraFisicaRetorno(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'Status') {
                        Status = parser.getText();
                    } else if (text == 'Data') {
                        Data = new Data(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'AmostraFisicaRetorno consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Tables {
        public String Name {get;set;} 
        public List<Structures> Structures {get;set;} 
        
        public Tables(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Name') {
                            Name = parser.getText();
                        } else if (text == 'Structures') {
                            Structures = arrayOfStructures(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Tables consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Structures {
        public String TYPE_Z {get;set;} // in json: TYPE
        public String ID {get;set;} 
        public String NUMBER_Z {get;set;} // in json: NUMBER
        public String MESSAGE {get;set;} 
        public String LOG_NO {get;set;} 
        public String LOG_MSG_NO {get;set;} 
        public String MESSAGE_V1 {get;set;} 
        public String MESSAGE_V2 {get;set;} 
        public String MESSAGE_V3 {get;set;} 
        public String MESSAGE_V4 {get;set;} 
        public String PARAMETER {get;set;} 
        public String ROW {get;set;} 
        public String SYSTEM_Z {get;set;} // in json: SYSTEM
        
        public Structures(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'TYPE') {
                            TYPE_Z = parser.getText();
                        } else if (text == 'ID') {
                            ID = parser.getText();
                        } else if (text == 'NUMBER') {
                            NUMBER_Z = parser.getText();
                        } else if (text == 'MESSAGE') {
                            MESSAGE = parser.getText();
                        } else if (text == 'LOG_NO') {
                            LOG_NO = parser.getText();
                        } else if (text == 'LOG_MSG_NO') {
                            LOG_MSG_NO = parser.getText();
                        } else if (text == 'MESSAGE_V1') {
                            MESSAGE_V1 = parser.getText();
                        } else if (text == 'MESSAGE_V2') {
                            MESSAGE_V2 = parser.getText();
                        } else if (text == 'MESSAGE_V3') {
                            MESSAGE_V3 = parser.getText();
                        } else if (text == 'MESSAGE_V4') {
                            MESSAGE_V4 = parser.getText();
                        } else if (text == 'PARAMETER') {
                            PARAMETER = parser.getText();
                        } else if (text == 'ROW') {
                            ROW = parser.getText();
                        } else if (text == 'SYSTEM') {
                            SYSTEM_Z = parser.getText();
                        } else {
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Data {
        public Exports Exports {get;set;} 
        public List<Tables> Tables {get;set;} 
        
        public Data(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Exports') {
                            Exports = new Exports(parser);
                        } else if (text == 'Tables') {
                            Tables = arrayOfTables(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Exports {
        public String VG_COUNT_ERROS {get;set;} 
        public String VG_VBELN {get;set;} 
        
        public Exports(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'VG_COUNT_ERROS') {
                            VG_COUNT_ERROS = parser.getText();
                        } else if (text == 'VG_VBELN') {
                            VG_VBELN = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Exports consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public static AmostraFisicaRetorno parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new AmostraFisicaRetorno(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT ||
                           curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
    private static List<Tables> arrayOfTables(System.JSONParser p) {
        List<Tables> res = new List<Tables>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Tables(p));
        }
        return res;
    }
    
    private static List<Structures> arrayOfStructures(System.JSONParser p) {
        List<Structures> res = new List<Structures>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Structures(p));
        }
        return res;
    }
}