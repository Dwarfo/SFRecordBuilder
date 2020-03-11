public with sharing class RecordBuilder_str {

    private Type sObjType;
    private Map<String, Object> fields{
        get;
        private set;
    }

    public RecordBuilder_str(Type sObjType) {
        this.sObjType = sObjType;
        this.fields = new Map<String, Object>();
    }

    public RecordBuilder_str(Type sObjType, SObject sObj){
        this.sObjType = sObjType;
        fields = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));
    }

    public RecordBuilder_str updateField(String fieldName, Object value){
        fields.put(fieldName, value);
        return this;
    }

    public RecordBuilder_str addFieldsInRelated(String relationName, sObject objToAdd){
        Map<String, Object> objToAddSerializedMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(objToAdd));
        fields.put(relationName, objToAddSerializedMap);
        return this;
    }

    public RecordBuilder_str insertChildrenRelationShip(String relationshipName, List<SObject> children){
    
        List<Map<String, Object>> childrenFields = new List<Map<String, Object>>();
        for(SObject sobj : children){
            childrenFields.add((Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sobj)));
        }

        Map<String,Object> childRelations = new Map<String, Object>();
        childRelations.put('done', true);
        childRelations.put('totalSize', childrenFields.size());
        childRelations.put('records', childrenFields);

        fields.put(relationshipName, childRelations);
        return this;
    }

    public sObject deserialize(){
        return (SObject)JSON.deserialize(JSON.serialize(fields), sObjType);
    }
}