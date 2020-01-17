public with sharing class COMBuildField {

    private Object value;
    private String fieldName;

    public COMBuildField(String fieldName){
        this.fieldName = fieldName;
    }

    public COMBuildField(Object val, String fieldName){
        this.value = val;
        this.fieldName = fieldName;
    }

    public void addValue(Object value){
        this.value = value;
    }

    public Map<String, Object> serialize(){

        Map<String, Object> resp;
        if(value instanceof COMBuildField){
            resp = new Map<String, Object>();
            COMBuildField v = (COMBuildField)value;
            Map<String, Object> serializedValue = v.serialize();

            resp = new Map<String, Object> { fieldName => serializedValue };
        }
        else {
            resp = new Map<String, Object> { fieldName => value };
        }

        return resp;
    }

}
