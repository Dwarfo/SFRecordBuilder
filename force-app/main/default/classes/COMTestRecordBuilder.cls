public with sharing class COMTestRecordBuilder {
    private Type sObjType;
    private Map<String, Object> fields{
        get;
        private set;
    }
    public COMTestRecordBuilder(Type sObjType) {
        this.sObjType = sObjType;
        this.fields = new Map<String, Object>();
    }
    public COMTestRecordBuilder(SObject sObj){
        this.sObjType = Type.forName(sObj.getSObjectType().GetDescribe().getName());
        fields = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));
    }
    public COMTestRecordBuilder updateField(String fieldName, Object value){
        fields.put(fieldName, value);
		return this;
    }
	public COMTestRecordBuilder addFieldsInRelated(String relationName, sObject objToAdd){
		Map<String, Object> objToAddSerializedMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(objToAdd));
		fields.put(relationName, objToAddSerializedMap);
		return this;
	}
    public COMTestRecordBuilder addFieldsInRelated(String relationName, String fieldName, Object value){
        Map<String, Object> fieldToAddSerializedMap;

        if(fields.containsKey(relationName))
            fieldToAddSerializedMap.get(relationName);
        else
		    fieldToAddSerializedMap = new Map<String, Object>();

        fieldToAddSerializedMap.put(fieldName, value);
		fields.put(relationName, fieldToAddSerializedMap);
		return this;
	}
    public COMTestRecordBuilder insertChildrenRelationShip(String relationshipName, List<SObject> children){
	
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
    public sObject serialize(){
        return (SObject)JSON.deserialize(JSON.serialize(fields), sObjType);
    }
}