public with sharing class COMFabricatedField {
    
    
    public class COMSimpleField implements COMIBaseField{
        
        protected String fieldName;
        protected Object value;

        public COMSimpleField(String fieldName, Object value) {
            this.fieldName = fieldName;
            this.value = value;
        }

        public Map<String, Object> serialize() {
            return new Map<String, Object> { fieldName => value };
        }
    }

    public class COMParentField implements COMIBaseField{
        
        private String fieldName;
        private COMFabricatedSObj parent;

        public COMParentField(String fieldName, COMFabricatedSObj parent) {
            this.fieldName = fieldName;
            this.parent = parent;
        }

        public Map<String, Object> serialize() {
            return new Map<String, Object> { fieldName => parent.serialize() };
        }
    }

    public class COMChildrenField implements COMIBaseField{

        private String fieldName;
        private List<COMFabricatedSObj> children;

        public COMChildrenField(String fieldName, List<COMFabricatedSObj> children) {
            this.fieldName = fieldName;
            this.children = children;
        }

        public Map<String, Object> serialize() {
            List<Map<String, Object>> serializedChildren = new List<Map<String, Object>>();

            for (COMFabricatedSObj child : children) {
                serializedChildren.add(child.serialize());
            }

            return new Map<String, Object> {
                    fieldName => new Map<String, Object> {
                            'totalSize' => children.size(),
                            'done' => true,
                            'records' => serializedChildren
                    }
            };
        }
    }
}
