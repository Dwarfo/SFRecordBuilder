public with sharing class IDGenerator
	{
		private Integer idIterator = 0;
		private final String ID_PATTERN = '000000000000';

		private IDGenerator() {}

		public Id generate(Schema.SObjectType sobjectType)
		{
			String sObjkeyPrefix = sobjectType.getDescribe().getKeyPrefix();
			idIterator++;
			String zeroFiller = ID_PATTERN.substring(0, 12 - String.valueOf(idIterator).length());

			return System.Id.valueOf(sObjkeyPrefix + zeroFiller + String.valueOf(idIterator));
		}
	}