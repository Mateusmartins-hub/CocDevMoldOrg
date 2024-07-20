public class ReclameAquiAnexoVO {
    public String attachmentLink;
    public String attachmentName;
    
    public static ReclameAquiAnexoVO parse(String json) {
        return (ReclameAquiAnexoVO) System.JSON.deserialize(json, ReclameAquiAnexoVO.class);
    }
}