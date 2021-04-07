public virtual class sql_Dao 
{
	public sql_Query query { get; set; }

	public sql_Dao()
	{
		query = new sql_Query();
	}

	public SObject getById(Id sobjId)
	{
		query.setCriteria(sql_Criteria.Equals('Id', sobjId));
		List<SObject> results = Database.query(query.buildQuery());

		if (results == null || results.isEmpty())
		{
			return null;
		}
		else if (results.size() > 1)
		{
			throw new DmlException('More than one row was found.');
		}
		else
		{
			return results[0];
		}
	}
	
	public List<SObject> getByIds(Set<Id> sobjIds)
	{
		query.setCriteria(sql_Criteria.ValueIn('Id', sobjIds));
		return Database.query(query.buildQuery());
	}

	public List<SObject> getAll()
	{
		query.setCriteria(null);
		return Database.query(query.buildQuery());
	}

	public List<SObject> getWhere(String criteria)
	{
		query.setCriteria(criteria);
		return Database.query(query.buildQuery());
	}

	public void setSObject(Schema.SObjectType sobjType)
	{
		setSObject(sobjType.getDescribe().getName());
	}

	public void setSObject(String sobjType)
	{
		query.setSObject(sobjType);
	}

	public void addField(Schema.SObjectField field)
	{
		addField(field.getDescribe().getName());
	}

	public void addField(String fieldName)
	{
		query.addField(fieldName);
	}

	public void addChild(sql_Query child)
	{
		query.addChild(child);
	}

	public void addOrderBy(sql_Order orderby)
	{
		query.addOrderBy(orderby);
	}
}