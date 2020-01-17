@isTest
public with sharing class COMSObjFactory {
    
    public static final IDGenerator IdGen = new IDGenerator();
    








    public with sharing class IDGenerator
	{
		private Integer fakeIdCount = 0;
		private final String ID_PATTERN = '000000000000';

		private IDGenerator() {}

		public Id generate(Schema.SObjectType sobjectType)
		{
			String keyPrefix = sobjectType.getDescribe().getKeyPrefix();
			fakeIdCount++;
			String fakeIdPrefix = ID_PATTERN.substring(0, 12 - fakeIdCount.format().length());
			return System.Id.valueOf(keyPrefix + fakeIdPrefix + fakeIdCount);
		}
	}	
}
