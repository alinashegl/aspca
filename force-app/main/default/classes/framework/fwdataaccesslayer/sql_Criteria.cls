public with sharing class sql_Criteria 
{
	public static String AndCriterias(List<String> criterias)
	{
		return getCriteriaBlock('AND', criterias);
	}

	public static String OrCriterias(List<String> criterias)
	{
		return getCriteriaBlock('OR', criterias);
	}

	private static String getCriteriaBlock(String junction, List<String> criterias)
	{
		String statement = '(';

		if (criterias != null && !criterias.isEmpty())
		{
			for (String criteria : criterias)
			{
				if (statement.length() > 1)
				{
					statement += ' ' + junction + ' ';
				}
				
				statement += criteria;
			}
		}

		statement += ')';
		return statement;
	}

	public static String Equals(Schema.SObjectField field, String value)
	{
		return Equals(field.getDescribe().getName(), value);
	}

	public static String Equals(String field, String value)
	{
		return field + ' = ' + sql_Utility.getQueryString(value);
	}

	public static String Equals(Schema.SObjectField field, Decimal value)
	{
		return Equals(field.getDescribe().getName(), value);
	}

	public static String Equals(String field, Decimal value)
	{
		return field + ' = ' + value;
	}

	public static String Equals(Schema.SObjectField field, Date value)
	{
		return Equals(field.getDescribe().getName(), value);
	}

	public static String Equals(String field, Date value)
	{
		return field + ' = ' + sql_Utility.getQueryDate(value);
	}

	public static String Equals(Schema.SObjectField field, Datetime value)
	{
		return Equals(field.getDescribe().getName(), value);
	}

	public static String Equals(String field, Datetime value)
	{
		return field + ' = ' + sql_Utility.getQueryDatetime(value);
	}

	public static String Equals(Schema.SObjectField field, Boolean value)
	{
		return Equals(field.getDescribe().getName(), value);
	}

	public static String Equals(String field, Boolean value)
	{
		return field + ' = ' + value;
	}

	public static String NotEquals(Schema.SObjectField field, String value)
	{
		return NotEquals(field.getDescribe().getName(), value);
	}

	public static String NotEquals(String field, String value)
	{
		return field + ' != ' + sql_Utility.getQueryString(value);
	}

	public static String NotEquals(Schema.SObjectField field, Decimal value)
	{
		return NotEquals(field.getDescribe().getName(), value);
	}

	public static String NotEquals(String field, Decimal value)
	{
		return field + ' != ' + value;
	}

	public static String NotEquals(Schema.SObjectField field, Date value)
	{
		return NotEquals(field.getDescribe().getName(), value);
	}

	public static String NotEquals(String field, Date value)
	{
		return field + ' != ' + sql_Utility.getQueryDate(value);
	}

	public static String NotEquals(Schema.SObjectField field, Datetime value)
	{
		return NotEquals(field.getDescribe().getName(), value);
	}

	public static String NotEquals(String field, Datetime value)
	{
		return field + ' != ' + sql_Utility.getQueryDatetime(value);
	}

	public static String NotEquals(Schema.SObjectField field, Boolean value)
	{
		return NotEquals(field.getDescribe().getName(), value);
	}

	public static String NotEquals(String field, Boolean value)
	{
		return field + ' != ' + value;
	}
    
    public static String GreaterThan(Schema.SObjectField field, Decimal value)
	{
		return GreaterThan(field.getDescribe().getName(), value);
	}

	public static String GreaterThan(String field, Decimal value)
	{
		return field + ' > ' + value;
	}

	public static String GreaterThan(Schema.SObjectField field, Date value)
	{
		return GreaterThan(field.getDescribe().getName(), value);
	}

	public static String GreaterThan(String field, Date value)
	{
		return field + ' > ' + sql_Utility.getQueryDate(value);
	}

	public static String GreaterThan(Schema.SObjectField field, Datetime value)
	{
		return GreaterThan(field.getDescribe().getName(), value);
	}

	public static String GreaterThan(String field, Datetime value)
	{
		return field + ' > ' + sql_Utility.getQueryDatetime(value);
	}

	public static String GreaterThanEquals(Schema.SObjectField field, Decimal value)
	{
		return GreaterThanEquals(field.getDescribe().getName(), value);
	}

	public static String GreaterThanEquals(String field, Decimal value)
	{
		return field + ' >= ' + value;
	}

	public static String GreaterThanEquals(Schema.SObjectField field, Date value)
	{
		return GreaterThanEquals(field.getDescribe().getName(), value);
	}

	public static String GreaterThanEquals(String field, Date value)
	{
		return field + ' >= ' + sql_Utility.getQueryDate(value);
	}

	public static String GreaterThanEquals(Schema.SObjectField field, Datetime value)
	{
		return GreaterThanEquals(field.getDescribe().getName(), value);
	}

	public static String GreaterThanEquals(String field, Datetime value)
	{
		return field + ' >= ' + sql_Utility.getQueryDatetime(value);
	}

	public static String LessThan(Schema.SObjectField field, Decimal value)
	{
		return LessThan(field.getDescribe().getName(), value);
	}

	public static String LessThan(String field, Decimal value)
	{
		return field + ' < ' + value;
	}

	public static String LessThan(Schema.SObjectField field, Date value)
	{
		return LessThan(field.getDescribe().getName(), value);
	}

	public static String LessThan(String field, Date value)
	{
		return field + ' < ' + sql_Utility.getQueryDate(value);
	}

	public static String LessThan(Schema.SObjectField field, Datetime value)
	{
		return LessThan(field.getDescribe().getName(), value);
	}

	public static String LessThan(String field, Datetime value)
	{
		return field + ' < ' + sql_Utility.getQueryDatetime(value);
	}

	public static String LessThanEquals(Schema.SObjectField field, Decimal value)
	{
		return LessThanEquals(field.getDescribe().getName(), value);
	}

	public static String LessThanEquals(String field, Decimal value)
	{
		return field + ' <= ' + value;
	}

	public static String LessThanEquals(Schema.SObjectField field, Date value)
	{
		return LessThanEquals(field.getDescribe().getName(), value);
	}

	public static String LessThanEquals(String field, Date value)
	{
		return field + ' <= ' + sql_Utility.getQueryDate(value);
	}

	public static String LessThanEquals(Schema.SObjectField field, Datetime value)
	{
		return LessThanEquals(field.getDescribe().getName(), value);
	}

	public static String LessThanEquals(String field, Datetime value)
	{
		return field + ' <= ' + sql_Utility.getQueryDatetime(value);
	}

	public static String BeginsWith(Schema.SObjectField field, String value)
	{
		return BeginsWith(field.getDescribe().getName(), value);
	}
    
    public static String BeginsWith(String field, String value)
    {
        return field + ' LIKE \'' + (value != null? String.escapeSingleQuotes(value) : value) + '%\'';
    }

    public static String EndsWith(Schema.SObjectField field, String value)
	{
		return EndsWith(field.getDescribe().getName(), value);
	}
    
    public static String EndsWith(String field, String value)
    {
        return field + ' LIKE \'%' + (value != null? String.escapeSingleQuotes(value) : value) + '\'';
    }

	public static String Contains(Schema.SObjectField field, String value)
	{
		return Contains(field.getDescribe().getName(), value);
	}
    
    public static String Contains(String field, String value)
    {
        return field + ' LIKE \'%' + (value != null? String.escapeSingleQuotes(value) : value) + '%\'';
    }

    public static String IsNull(Schema.SObjectField field)
	{
		return IsNull(field.getDescribe().getName());
	}

    public static String IsNull(String field)
    {
        return field + ' = NULL';
    }

    public static String IsNotNull(Schema.SObjectField field)
	{
		return IsNotNull(field.getDescribe().getName());
	}
    
    public static String IsNotNull(String field)
    {
        return field + ' != NULL';
    }

    public static String ValueIn(Schema.SObjectField field, Set<Id> ids)
    {
    	return ValueIn(field.getDescribe().getName(), ids);
    }

    public static String ValueIn(String field, Set<Id> ids)
    {
    	return field + ' IN (' + sql_Utility.getQueryList(ids) + ')';
    }

    public static String ValueIn(Schema.SObjectField field, Set<String> values)
    {
    	return ValueIn(field.getDescribe().getName(), values);
    }

    public static String ValueIn(String field, Set<String> values)
    {
    	return field + ' IN (' + sql_Utility.getQueryList(values) + ')';
    }

    public static String ValueIn(Schema.SObjectField field, sql_Query nestedQuery)
    {
    	return field + ' IN (' + nestedQuery.buildQuery() + ')'; 
    }

    public static String ValueNotIn(Schema.SObjectField field, Set<Id> ids)
    {
    	return ValueNotIn(field.getDescribe().getName(), ids);
    }

    public static String ValueNotIn(String field, Set<Id> ids)
    {
    	return field + ' NOT IN (' + sql_Utility.getQueryList(ids) + ')';
    }

    public static String ValueNotIn(Schema.SObjectField field, Set<String> values)
    {
    	return ValueNotIn(field.getDescribe().getName(), values);
    }

    public static String ValueNotIn(String field, Set<String> values)
    {
    	return field + ' NOT IN (' + sql_Utility.getQueryList(values) + ')';
    }

    public static String ValueNotIn(Schema.SObjectField field, sql_Query nestedQuery)
    {
    	return field + ' NOT IN (' + nestedQuery.buildQuery() + ')'; 
    }
}