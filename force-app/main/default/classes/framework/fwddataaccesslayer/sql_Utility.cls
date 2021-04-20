public with sharing class sql_Utility 
{
	public static Set<String> getValues(Schema.SObjectField field, List<SObject> records)
	{
		return getValues(field.getDescribe().getName(), records);
	}

	public static Set<String> getValues(String fieldName, List<SObject> records)
	{
		Set<String> values = new Set<String>();

		if (records != null && !records.isEmpty())
		{
			for (SObject record : records)
			{
				Object fieldValue = record.get(fieldName);

				if (fieldValue != null)
				{
					values.add((String) fieldValue);
				}
			}
		}

		return values;
	}

	public static Set<Id> getIds(Schema.SObjectField field, List<SObject> records)
	{
		return getIds(field.getDescribe().getName(), records);
	}

	public static Set<Id> getIds(String fieldName, List<SObject> records)
	{
		Set<Id> ids = new Set<Id>();

		if (records != null && !records.isEmpty())
		{
			for (SObject record : records)
			{
				Object fieldValue = record.get(fieldName);

				if (fieldValue != null)
				{
					ids.add((Id) fieldValue);
				}
			}
		}

		return ids;
	}

	public static Set<Id> getIdsFor(Schema.sObjectType stype, Schema.SObjectField field, List<SObject> records)
	{
		return getIdsFor(stype, field.getDescribe().getName(), records);
	}

	public static Set<Id> getIdsFor(Schema.sObjectType stype, String fieldName, List<SObject> records)
	{
		Set<Id> ids = getIds(fieldName, records);
		Set<Id> stids = new Set<Id>();

		for (Id cid : ids)
		{
			String sid = cid;

			if (sid.startsWith(stype.getDescribe().getKeyPrefix()))
			{
				stids.add(cid);
			}
		}

		return stids;
	}
	
	public static String getDateStringValue(Integer value)
	{
		return (value < 10 ? '0' + value : '' + value);
	}

	public static String getQueryString(String value)
	{
		return (String.isNotBlank(value) ? '\'' + String.escapeSingleQuotes(value) + '\'' : 'null');
	}

	/*
	public static String getFirstPartOfString(String value, Integer numOfChars)
	{
		if (!String.isBlank(value))
		{
			if (value.length() > numOfChars)
			{
				return value.substring(0, numOfChars - 1);
			}
			else
			{
				return value;
			} 
		}

		return null;
	}
	*/

	public static String getQueryDate(Date value)
	{
		if (value == null)
		{
			return 'null';
		}
		else 
		{
			String formattedDate = String.valueOf(value.year());
			formattedDate += '-' + getDateStringValue(value.month());
			formattedDate += '-' + getDateStringValue(value.day());
			return formattedDate;
		}
	}

	public static String getQueryDatetime(Datetime value)
	{
		return (value == null ? 'null' : value.formatGmt('yyyy-MM-dd HH:mm:ss').replace(' ','T')+'Z');
	}

	public static String getQueryList(Set<Id> ids)
	{
		String query = '';

		if (ids != null && !ids.isEmpty())
		{
			for (Id sobjId : ids)
			{

				if (query.length() > 0)
				{
					query += ', ';
				}

				query += '\'' + sobjId + '\'';
			}
		}

		return query;
	}

	public static String getQueryList(Set<String> values)
	{
		String query = '';

		if (values != null && !values.isEmpty())
		{
			for (String value : values)
			{

				if (query.length() > 0)
				{
					query += ', ';
				}

				query += '\'' + value + '\'';
			}
		}

		return query;
	}
}