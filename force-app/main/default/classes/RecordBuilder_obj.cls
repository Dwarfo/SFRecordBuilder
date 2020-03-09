public with sharing class RecordBuilder_obj {
    private Type sObjType;

    //#region objectbased fields and relationships
    private Map<Schema.SObjectField, Schema.DescribeFieldResult> fieldToDescribe;
    private Map<Schema.DescribeFieldResult, Object> serializedSObjFields;

    private Map<String, List<SObject>> relationNameToChildren;
    private Map<Schema.ChildRelationship, Map<Schema.SObjectField, Object>> serializedSObjRelations;
    private Map<String, Schema.ChildRelationship> relNameToRelationship;

    //#endregion

    public RecordBuilder_obj(Type sObjType) {
        this.sObjType = sObjType;
    }

    public RecordBuilder_obj(SObject sObj){
        
        serializedSObjFields = serializeSObjectFields(sObj);

        relNameToRelationship = new Map<String, Schema.ChildRelationship>();
        for(Schema.ChildRelationship rel : serializedSObjRelations.keySet()){
            relNameToRelationship.put(rel.getRelationshipName(), rel);
        }
    }

    public RecordBuilder_obj updateField(Schema.SObjectField field, Object value){
        if(fieldToDescribe.containsKey(field)){
            serializedSObjFields.put(fieldToDescribe.get(field), value);
        }
        return this;
    }

    public RecordBuilder_obj insertChildrenRelationShip(String relationshipName, List<SObject> children){
        relationNameToChildren.put(relationshipName, children);
        return this;
    }
    
    public sObject serialize(){
        
        Map<String, Object> finalFieldMap = new Map<String, Object>();

        for(Schema.SObjectField field : fieldToDescribe.keySet()){
            Schema.DescribeFieldResult fieldDescr = fieldToDescribe.get(field);
            String fieldName = fieldDescr.name;
            finalFieldMap.put(fieldName, fieldDescr);
        }
        
        for(String relName : relationNameToChildren.keySet()){
            List<Map<String, Object>> childrenFields = new List<Map<String, Object>>();
            List<SObject> children = relationNameToChildren.get(relName);

            for(SObject sobj : children){
                childrenFields.add((Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sobj)));
            }

            Map<String,Object> childRelations = new Map<String, Object>();
            childRelations.put('done', true);
            childRelations.put('totalSize', childrenFields.size());
            childRelations.put('records', childrenFields);


            finalFieldMap.put(relName, childRelations);
        }

        return (SObject)JSON.deserialize(JSON.serialize(finalFieldMap), sObjType);
    }

    private Map<Schema.DescribeFieldResult, Object> serializeSObjectFields(SObject sObj){
        Schema.DescribeSObjectResult objectDescribe = sObj.getSObjectType().GetDescribe();
        Map<String, Object> rawFields = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));

        Map<String, Object> rawFieldValues = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));

        Map<Schema.DescribeFieldResult, Object> objectFields = new Map<Schema.DescribeFieldResult, Object>();
        for(Schema.SObjectField fld : objectDescribe.fields.getMap().values()){
            Schema.DescribeFieldResult dfr = fld.getDescribe();
            if(rawFields.containsKey(dfr.Name)){
                fieldToDescribe.put(fld, dfr);
                objectFields.put(dfr, rawFields.get(dfr.Name));
            }
        }

        return objectFields;
    }

    private Map<Schema.ChildRelationship, Map<Schema.SObjectField, Object>> serializeSObjectRelationships(SObject sObj){
        Schema.DescribeSObjectResult objectDescribe = sObj.getSObjectType().GetDescribe();
        Map<String, Object> rawFields = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));

        Map<Schema.ChildRelationship, Map<Schema.SObjectField, Object>> relationshipToFields = new Map<Schema.ChildRelationship, Map<Schema.SObjectField, Object>>();
        for(Schema.ChildRelationship r : objectDescribe.getChildRelationships()){

            Schema.SObjectType childType = r.getChildSObject();
            Schema.DescribeSObjectResult childObjectDescribe = childType.getDescribe();

            Map<Schema.SObjectField, Object> fieldToValueMap = new Map<Schema.SObjectField, Object>();
            for(Schema.SObjectField fld : objectDescribe.fields.getMap().values()){

                DescribeFieldResult dfr = fld.getDescribe();
                if(rawFields.containsKey(dfr.Name)){
                    fieldToValueMap.put(fld, rawFields.get(dfr.Name));
                }
            }

            relationshipToFields.put(r, fieldToValueMap);
        }
        return relationshipToFields;
    }
}
