public with sharing class sql_Order 
{
	private String orderby;

	private sql_Order(String newOrderBy) 
	{
		orderby = newOrderBy;
	}

	public String getOrderBy()
	{
		return orderby;
	}

	public static sql_Order Ascending(Schema.SObjectField field)
	{
		return Ascending(field.getDescribe().getName());
	}

	public static sql_Order Ascending(String field)
	{
		return new sql_Order(field + ' ASC');
	}

	public static sql_Order Descending(Schema.SObjectField field)
	{
		return Descending(field.getDescribe().getName());
	}

	public static sql_Order Descending(String field)
	{
		return new sql_Order(field + ' DESC');
	}
}