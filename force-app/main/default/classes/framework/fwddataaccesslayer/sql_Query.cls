public with sharing class sql_Query 
{
	public String sObjName { get; set; }
	public Set<String> fieldNames { get; set; }
	public String criteria { get; set; }
	public List<sql_Query> children { get; set; }
	public List<sql_Order> orderBys { get; set; }

	public sql_Query()
	{
		fieldNames = new Set<String>();
		children = new List<sql_Query>();
		orderBys = new List<sql_Order>();
	}

	public void setSObject(Schema.SObjectType sObjType)
	{
		setSObject(sObjType.getDescribe().getName());
	}

	public void setSObject(String sObjTypeName)
	{
		sObjName = sObjTypeName;
	}

	public void addField(Schema.SObjectField field)
	{
		addField(field.getDescribe().getName());
	}

	public void addField(String field)
	{
		fieldNames.add(field);
	}

	public void addChild(sql_Query child)
	{
		children.add(child);
	}

	public void setCriteria(String pCriteria)
	{
		criteria = pCriteria;
	}

	public void addOrderBy(sql_Order orderby)
	{
		orderBys.add(orderby);
	}

	public String buildQuery()
	{
		String selectstatement = '';
		selectstatement += getSelect();
		selectstatement += getFrom();
		selectstatement += getWhere();
		selectstatement += getOrderBy();

		System.debug('@@@ QUERY: ' + selectstatement);

		return selectstatement;
	}

	private String getSelect()
	{
		String selectstatement = 'SELECT ';

		for (String field : fieldNames)
		{
			if (selectstatement.length() > 7)
			{
				selectstatement += ', ';
			}

			selectstatement += field;
		}

		selectstatement += getChildren();

		return selectstatement;
	}

	private String getChildren()
	{
		String selectstatement = '';

		if (children != null && !children.isEmpty())
		{
			for (sql_Query child : children)
			{
				selectstatement += ', (' + child.buildQuery() + ')';
			}
		}

		return selectstatement;
	}

	private String getFrom()
	{
		return ' FROM ' + sObjName;
	}

	private String getWhere()
	{
		String whereclause = '';

		if (String.isNotBlank(criteria))
		{
			whereclause += ' WHERE ' + criteria;
		}

		return whereclause;
	}

	private String getOrderBy()
	{
		String orderstatement = '';

		if (orderBys != null && !orderBys.isEmpty())
		{
			orderstatement += ' ORDER BY ';

			for (sql_Order orderby : orderBys)
			{
				if (orderstatement.length() > 10)
				{
					orderstatement += ', ';
				}

				orderstatement += orderby.getOrderBy();
			}
		}

		return orderstatement;
	}
}