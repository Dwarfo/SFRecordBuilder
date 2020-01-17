public with sharing class COMTestRecordBuilder {
    private Type sObjType;

    //#region objectbased fields and relationships
    private Map<Schema.SObjectField, Schema.DescribeFieldResult> fieldToDescribe;
    private Map<Schema.DescribeFieldResul, Object> serializedSObjFields;

    private Map<String, List<SObject>> relationNameToChildren;
    private Map<Schema.ChildRelationship, Map<Schema.SObjectField, Object>> serializedSObjRelations;
    private Map<String, Schema.ChildRelationship> relNameToRelationship;

    //#endregion

    public COMTestRecordBuilder(Type sObjType) {
        this.sObjType = sObjType;
    }

    public COMTestRecordBuilder(SObject sObj){
        
        serializedSObjFields = serializeSObjectFields(sObj);


        relNameToRelationship = new Map<String, Schema.ChildRelationship>();
        for(Schema.ChildRelationship rel : serializedSObjRelations.keySet()){
            relNameToRelationship.put(rel.getRelationshipName(), rel);
        }
    }

    public COMTestRecordBuilder updateField(Schema.SObjectField field, Object value){
        if(serializedSObjFields.containsKey(field)){
            objFields.put(field, value);
        }
    }

    public COMTestRecordBuilder insertChildrenRelationShip(String relationshipName, List<SObject> children){
        relationNameToChildren.put(relationshipName, children);
    }
    
    public sObject serialize(){
        
        Map<String, Object> objectFields = new Map<String, Object>();
        for(Schema.SObjectField field : serializedSObjFields.keySet()){
            String fieldName = fieldToDescribe.get(field).name;
            objectFields.put(fieldName, serializedSObjFields.get(field));
        }
        
        for(String keys : relationNameToChildren.keySet()){
            

            Map<String,Object> childRelations = new Map<String, Object>();
            childRelations.put('done', true);
            childRelations.put('totalSize', childrenFields.size());
            childRelations.put('records', childrenFields);
            fields.put(relationshipName, childRelations);
        }

        return (SObject)JSON.deserialize(JSON.serialize(fields), sObjType);
    }

    private Map<Schema.SObjectField, Object> serializeSObjectFields(SObject sObj){
        Schema.DescribeSObjectResult objectDescribe = sObj.getSObjectType().GetDescribe();
        Map<String, Object> rawFields = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));

        Map<String, Object> rawFieldValues = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));

        Map<Schema.SObjectField, Object> objectFields = new Map<Schema.SObjectField, Object>();
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
                    fieldToValueMap.put(dfr, rawFields.get(dfr.Name));
                }
            }

            relationshipToFields.put(r, fieldToValueMap);
        }
        return relationshipToFields;
    }
}


/*
//#region Anonymous debug
sObject acc = [SELECT Id, Name, (SELECT ID FROM Contacts) FROM Account WHERE Id = '0016E00000usZtiQAE'];
System.debug('Record: ' + acc);

Map<String, Object> childrenRels = new Map<String, Object>();
Map<String, Object> rawFields = new Map<String, Object>();
Map<String, Object> fields = new Map<String, Object>();
Map<Schema.ChildRelationship, Object> objRelations = new Map<Schema.ChildRelationship, Object>();

Schema.DescribeSObjectResult objectDescribe = acc.getSObjectType().GetDescribe();
rawFields = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(acc));
Type sObjType = Type.forName(objectDescribe.getName());

for(Schema.ChildRelationship r : objectDescribe.getChildRelationships()){
            String relName = r.getRelationshipName();
            childrenRels.put(relName, rawFields.get(relName));
            objRelations.put(r, rawFields.get(relName));
            Map<String, Object> childRelData;
        }

System.Debug(childrenRels);


//#endregion
*/