public class COMFabricatedSObj {
    
    private Type sObjType;
    private List<COMIBaseField> nodes = new List<COMIBaseField>();

    public COMFabricatedSObj(Type sObjType) {
        this.sObjType = sObjType;
    }

    public COMFabricatedSObj(SObject sObj){

        JSONParser objParser = JSON.createParser(JSON.serialize(sObj));

        Integer depth = 0;

		while (objParser.nextToken()!=null)
		{
			JSONToken currentToken = objParser.getCurrentToken();
			if(currentToken == JSONToken.FIELD_NAME){
                COMBuildField bf = new COMBuildField()
            }
			else if(currentToken == JSONToken.VALUE_STRING ||
					currentToken == JSONToken.VALUE_FALSE ||
					currentToken == JSONToken.VALUE_TRUE ||
					currentToken == JSONToken.VALUE_NUMBER_FLOAT ||
					currentToken == JSONToken.VALUE_NUMBER_INT){

                }
			
		}
        /*this.sObjType = sObj.class;
        for(){

        }*/
    }

    //228acc - 0012o00002XuLKVAA3
    //229acc - 0012o00002XuLhnAAF
    // cont1 - 0032o00002eAhJBAA0
    // cont2 - 

    
    Account ct = [SELECT Id, (SELECT id FROM Contacts) FROM Account WHERE id = '0012o00002XuLhnAAF' LIMIT 1];
    Contact con = [SELECT Id, AccountId FROM Contact WHERE id = '0032o00002eAhJBAA0' LIMIT 1];

    JSONParser objParser = JSON.createParser(JSON.serialize(ct));
    
    Map<String, Object> mp = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(ct));
    System.debug('Acc before adding contacts ' + ct);
    System.debug('Related contacts: ' + ct.Contacts);


    Map<String, Object> serealizedContact = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(con));
    mp.put('Contacts', new Map<String,Object>());
    Map<String,Object> realtedCts = (Map<String,Object>)mp.get('Contacts');
    realtedCts.put('done', true);
    realtedCts.put('totalSize', 1);
    realtedCts.put('records', new List<Map<String, Object>>{ serealizedContact});

    Account mockedAcc = (Account)JSON.deserialize(JSON.serialize(mp), Account.class);
    System.debug('Acc after adding contacts ' + mockedAcc);
    System.debug('Related contacts: ' + mockedAcc.Contacts);

    public COMFabricatedSObj(Type sObjType, Map<Schema.SObjectField, Object> fields) {
        this(sObjType);

        for (Schema.SObjectField field : fields.keySet()) {
            setField(field.getDescribe().getName(), fields.get(field));
        }
    }

    public COMFabricatedSObj(Type sObjType, List<COMIBaseField> nodes) {
        this.sObjType = sObjType;
        this.nodes = nodes;
    }

    public COMFabricatedSObj setField(String fieldName, Object value) {
        nodes.add(new COMFabricatedField.COMSimpleField(fieldName, value));
        return this;
    }

    public COMFabricatedSObj setParent(String relationshipName, COMFabricatedSObj fabricatedParent) {
        nodes.add(new COMFabricatedField.COMParentField(relationshipName, fabricatedParent));
        return this;
    }

    public COMFabricatedSObj setChildren(String relationshipName, List<COMFabricatedSObj> fabricatedChildren) {
        nodes.add(new COMFabricatedField.COMChildrenField(relationshipName, fabricatedChildren));
        return this;
    }

    public SObject toSObject() {
        return (SObject)JSON.deserialize(JSON.serialize(this.serialize()), sObjType);
    }

    public virtual Map<String, Object> serialize() {
        Map<String, Object> fields = new Map<String, Object>();

        for (COMIBaseField node : nodes) {
            fields.putAll(node.serialize());
        }

        return fields;
    }
}
