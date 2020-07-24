# SFRecordBuilder
RecordBuilder for creating records used in testing classes, ommiting security settings, validations and other functionality not in scope of test. Can populate child relationships, fields in parent relationships and update fields in records.

RecordBuilder has 2 variations: 
  1. String based: As 1st argument in methods requires field name as string 
  2. Schema based: As 1st argument in methods requies Schema.SObjectField object of specific field __(Untested)__.
  
## Methods and constructors (string based)
Described methods ommit any kind of validations and security settings, because internally they work on String/Object maps instead of actual sObject records. All methods return the instance of record builder, that they belong to (this).

* ### Constructors:
  * `RecordBuilder_str(Type sObjType)` - constructs creates record builder with no field values set. Required only sObject Type as argument for deserialization.
  * `RecordBuilder_str(Type sObjType, SObject sObj)` - creates record builder with some of the fields already having same values as record passed as second parameter.
* ###  Methods:
  * `updateField(String fieldName, Object value)`:
      use this method to update field value, as first argument pass field api name as string, as second value that you want to assign to this field.
  * `addFieldsInRelated(String relationName, sObject objToAdd)`:
      use this method to add all required fields in related sObject (master object, or lookup). As first argument pass string api name of relationship field, as second pass sObject you with fields having required values.
  * `insertChildrenRelationShip(String relationshipName, List<SObject> children)`:
      use this method to add records to child relationships. As first argument pass string api name of relationship as second pass list of sObjects you want to be available in relationship.
  * `deserialize()`:
      use this method to retrieve sObject record, after all required adjustments have been made. 
