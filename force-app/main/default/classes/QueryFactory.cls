/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public inherited sharing class QueryFactory implements iQueryFactory{
    private static final String LOG_PREFIX = '[][][QueryFactory] ';
    private static final String DOT = '.';
    private Schema.SObjectType m_type { get; set; }
    private Set<Schema.SObjectField> m_fields { get; set; }
    private iCriteria m_criteria { get; set; }
    private List<iQueryFactory> m_childQueries { get; set; }
    private List<iOrderBy> m_orderBys { get; set; }
    private List<RelatedField> m_relationshipFields { get; set; }
    private Boolean m_useRelationshipFields { get; set; }
    private Integer m_rowLimit { get; set; }

    /**
     * Constructor
     * @param  forType  Schema.SObjectType  The SObjectType this QueryFactory processes against
     */
    public QueryFactory(Schema.SObjectType forType) {
        initialize(forType, new Set<Schema.SObjectField>(), null);
    }

    /**
     * Constructor
     * @param  forType        Schema.SObjectType        The SObjectType this QueryFactory processes against
     * @param  includeFields  List<Schema.SObjectField> The Fields to include in all queries
     */
    public QueryFactory(Schema.SObjectType forType, Set<Schema.SObjectField> includeFields) {
        initialize(forType, includeFields, null);
    }

    /**
     * Constructor
     * @param  forType        Schema.SObjectType        The SObjectType this QueryFactory processes against
     * @param  defaultOrderBy List<OrderBy>        The OrderBy to use by default
     */
    public QueryFactory(Schema.SObjectType forType, List<iOrderBy> defaultOrderBy) {
        initialize(forType, new Set<Schema.SObjectField>(), defaultOrderBy);
    }

    /**
     * Constructor
     * @param  forType        Schema.SObjectType        The SObjectType this QueryFactory processes against
     * @param  includeFields  List<Schema.SObjectField> The Fields to include in all queries
     * @param  defaultOrderBy List<OrderBy>        The OrderBy to use by default
     */
    public QueryFactory(Schema.SObjectType forType, Set<Schema.SObjectField> includeFields, List<iOrderBy>
            defaultOrderBy) {
        initialize(forType, includeFields, defaultOrderBy);
    }

    /**
     * Retrieves the SObjectType that this QueryFactory is generating SOQL on behalf of
     * @return  Schema.SObjectType
     */
    public Schema.SObjectType GetUnderlyingType() { return m_type; }

    /**
     * Fluently adds a field to the SELECT portion of the Query
     * @param  field    Schema.SObjectField The SObjectField to include in the Query
     * @return       The current instance of this QueryFactory
     */
    public iQueryFactory WithField(Schema.SObjectField field) {
        if (field != null && !m_fields.contains(field)) {
            m_fields.add(field);
        }
        return this;
    }

    /**
     * Fluently adds a field to the SELECT portion of the Query
     * @param  fields   List<Schema.SObjectField>   The SObjectFields to include in the Query
     * @return          The current instance of this QueryFactory
     */
    public iQueryFactory WithFields(List<Schema.SObjectField> fields) {
        if (fields == null || fields.isEmpty()) { return this; }
        for (Schema.SObjectField field : fields) {
            withField(field);
        }
        return this;
    }

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this QueryFactory
     */
    public iQueryFactory WithRelatedField(Schema.SObjectField relatedField, Schema.SObjectField fieldOnRelation) {
        if (relatedField != null && fieldOnRelation != null) {
            m_relationshipFields.add(new QueryFactory.RelatedField(relatedField, fieldOnRelation));
            m_useRelationshipFields = true;
        }
        return this;
    }

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField2    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this QueryFactory
     */
    public iQueryFactory WithRelatedField(Schema.SObjectField relatedField
            , Schema.SObjectField relatedField2, Schema.SObjectField fieldOnRelation) {
        if (relatedField != null && relatedField2 != null && fieldOnRelation != null) {
            m_relationshipFields.add(new QueryFactory.RelatedField(relatedField, relatedField2, fieldOnRelation));
            m_useRelationshipFields = true;
        }
        return this;
    }

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField2    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField3    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this QueryFactory
     */
    public iQueryFactory WithRelatedField(Schema.SObjectField relatedField
            , Schema.SObjectField relatedField2, Schema.SObjectField relatedField3, Schema.SObjectField fieldOnRelation) {
        if (relatedField != null && relatedField2 != null && relatedField3 != null && fieldOnRelation != null) {
            m_relationshipFields.add(new QueryFactory.RelatedField(relatedField, relatedField2, relatedField3,
                    fieldOnRelation));
            m_useRelationshipFields = true;
        }
        return this;
    }

    /**
     * Fluently applies a Child query to include in the results
     * @param  child    QueryFactory A Child query to include in the results
     * @return       The current instance of this QueryFactory
     */
    public iQueryFactory WithChildQuery(iQueryFactory child) {
        if (child != null) {
            m_childQueries.add(child);
        }
        return this;
    }

    /**
     * Fluently applies the Criteria used for the Query
     * @param  conditions Criteria   The Criteria to use to filter the Query
     * @return            The current instance of this QueryFactory
     */
    public iQueryFactory WithCriteria(iCriteria conditions) {
        if (conditions != null) {
            m_criteria = conditions;
        }
        return this;
    }

    /**
     * Fluently clears the existing sort order, if any
     * @return   The current instance of this QueryFactory
     */
    public iQueryFactory ClearExistingOrder() {
        m_orderBys = new List<iOrderBy>();
        return this;
    }

    /**
     * Fluently applies the sort order for the Query
     * @param  orderBy  OrderBy    Sort order for the resulting Query
     * @return         The current instance of this QueryFactory
     */
    public iQueryFactory WithOrderBy(iOrderBy orderBy) {
        if (orderBy != null) {
            m_orderBys.add(orderBy);
        }
        return this;
    }

    /**
     * Fluently applies the sort order for the Query
     * @param  orderBys List<OrderBy>  Sort order for the resulting Query
     * @return         The current instance of this QueryFactory
     */
    public iQueryFactory WithOrderBys(List<iOrderBy> orderBys) {
        if (orderBys == null || orderBys.isEmpty()) { return this; }
        for (iOrderBy OrderBy : orderBys) {
            WithOrderBy(OrderBy);
        }
        return this;
    }

    /**
     * Fluently adds a field to the sorting of the Query
     * @param  field    Schema.SObjectField The SObjectField to sort by Ascending
     * @return       The current instance of this QueryFactory
     */
    public iQueryFactory OrderAscending(Schema.SObjectField field) {
        m_orderBys.add(OrderBy.Ascending(field));
        return this;
    }

    /**
     * Fluently adds a field to the sorting of the Query
     * @param  field    Schema.SObjectField The SObjectField to sort by Descending
     * @return       The current instance of this QueryFactory
     */
    public iQueryFactory OrderDescending(Schema.SObjectField field) {
        m_orderBys.add(OrderBy.Descending(field));
        return this;
    }

    /**
     * Fluently applies a Row Limit to the Query results
     * @param  rowLimit Integer The number of rows to retrieve
     * @return          The current instance of this QueryFactory
     */
    public iQueryFactory WithRowLimit(Integer rowLimit) {
        if (rowLimit != null && rowLimit > 0) {
            m_rowLimit = rowLimit;
        }
        return this;
    }

    /**
     * Generates the SOQL statement used to perform the Query
     * @return   String
     */
    public String GenerateSoql() {
        String soql = '';
        soql += generateSelect();
        soql += generateFrom();
        soql += generateWhere();
        soql += generateOrderBy();
        soql += generateLimit();
        if (Test.isRunningTest()) {
            System.debug(LOG_PREFIX + 'Generated SOQL :: ' + soql);
        }
        return soql;
    }

    /**
     * Generates the SOQL for nesting inside another query
     * @param   relateOn    String  relationship name to use instead of SObjectName
     * @return  String
     */
    public String GenerateSoqlNested(String relateOn) {
        String soql = '';
        soql += generateSelect();
        soql += generateFrom(relateOn);
        soql += generateWhere();
        if (Test.isRunningTest()) {
            System.debug(LOG_PREFIX + 'Generated SOQL :: ' + soql);
        }
        return soql;
    }

    /**
     * Executes the query produced by GenerateSoql() method
     * @return   List<SObject>
     */
    public List<SObject> Execute() {
        String soql = '';
        try {
            soql = GenerateSoql();
            System.debug(LOG_PREFIX + 'Executing SOQL :: ' + soql);
            return (List<SObject>) Database.query(soql);
        } catch (Exception ex) {
            System.debug(LOG_PREFIX + ' Error Executing SOQL :: ' + soql);
            System.debug(ex);
        }
        return new List<SObject>();
    }

    private void initialize(Schema.SObjectType forType, Set<Schema.SObjectField> includeFields, List<iOrderBy>
            defaultOrderBy) {
        m_type = forType;
        m_fields = includeFields;
        m_relationshipFields = new List<RelatedField>();
        m_useRelationshipFields = false;
        m_childQueries = new List<iQueryFactory>();
        m_orderBys = new List<iOrderBy>();
        if (defaultOrderBy != null) {
            m_orderBys.addAll(defaultOrderBy);
        }
    }

    private String generateSelect() {
        String soql = 'SELECT ';
        Integer lenBefore = soql.length();
        soql += generateFields();
        soql += generateRelatedFields();
        soql += generateChildQueries();
        return soql;
    }

    private String generateFields() {
        String soql = '';
        for (Schema.SObjectField field : m_fields) {
            if (soql.length() > 1) {
                soql += ', ';
            }
            soql += SchemaHelper.GetDescribe(field).getName();
        }
        return soql;
    }

    private String generateRelatedFields() {
        String soql = '';
        if (m_useRelationshipFields) {
            for (RelatedField field : m_relationshipFields) {
                soql += ', ' + field.ForSoql();
            }
            m_useRelationshipFields = false;
        }
        return soql;
    }

    private String generateChildQueries() {
        String soql = '';
        if (m_childQueries == null || m_childQueries.isEmpty()) { return soql; }
        for (iQueryFactory child : m_childQueries) {
            String relationName;
            Schema.SObjectType childType = child.GetUnderlyingType();

            for (Schema.ChildRelationship relation : SchemaHelper.GetDescribe(m_type).getChildRelationships()) {
                if (relation.getChildSObject() == childType) {
                    relationName = relation.getRelationshipName();
                    break;
                }
            }

            if (relationName == null || String.isBlank(relationName)) { continue; }
            soql += ', (' + child.clearExistingOrder().GenerateSoqlNested(relationName) + ')';
        }
        return soql;
    }

    private String generateFrom() {
        return ' FROM ' + SchemaHelper.GetDescribe(m_type).getName();
    }

    private String generateFrom(String relation) {
        return ' FROM ' + relation;
    }

    private String generateWhere() {
        if (m_criteria == null) { return ''; }
        String conditions = m_criteria.ForSoql();
        if (String.isBlank(conditions)) { return ''; }
        return ' WHERE ' + conditions;
    }

    private String generateOrderBy() {
        String soql = '';
        if (m_orderBys != null && !m_orderBys.isEmpty()) {
            soql += ' ORDER BY ';
            for (iOrderBy OrderBy : m_orderBys) {
                if (soql.length() > 10) { soql += ', '; }
                soql += OrderBy.ForSoql();
            }
        }
        return soql;
    }

    private String generateLimit() {
        return (m_rowLimit != null && m_rowLimit > 0) ? ' LIMIT ' + String.valueOf(m_rowLimit) : '';
    }

    private class RelatedField {
        private Schema.SObjectField m_local         { get; set; }
        private Schema.SObjectField m_local2        { get; set; }
        private Schema.SObjectField m_local3        { get; set; }
        private Schema.SObjectField m_field         { get; set; }

        private Boolean layer2 = false;
        private Boolean layer3 = false;
        private Boolean skipMe = false;

        public RelatedField(Schema.SObjectField localField, Schema.SObjectField targetField) {
            m_local = localField;
            m_field = targetField;
        }

        public RelatedField(Schema.SObjectField localField, Schema.SObjectField localField2
                , Schema.SObjectField targetField) {
            m_local     = localField;
            m_local2    = localField2;
            m_field     = targetField;
            if (m_local2 != null) {
                layer2 = true;
            } else {
                skipMe = true;
            }
        }

        public RelatedField(Schema.SObjectField localField, Schema.SObjectField localField2
                , Schema.SObjectField localField3, Schema.SObjectField targetField) {
            m_local     = localField;
            m_local2    = localField2;
            m_local3    = localField3;
            m_field     = targetField;
            if (m_local2 != null && m_local3 != null) {
                layer3 = true;
            } else {
                skipMe = true;
            }
        }

        public String ForSoql() {
            if (skipMe) { return ''; }
            if (layer3) {
                return SchemaHelper.GetDescribe(m_local).getRelationshipName() + DOT
                        + SchemaHelper.GetDescribe(m_local2).getRelationshipName() + DOT
                        + SchemaHelper.GetDescribe(m_local3).getRelationshipName() + DOT
                        + SchemaHelper.GetDescribe(m_field).getName();
            }
            if (layer2) {
                return SchemaHelper.GetDescribe(m_local).getRelationshipName() + DOT
                        + SchemaHelper.GetDescribe(m_local2).getRelationshipName() + DOT
                        + SchemaHelper.GetDescribe(m_field).getName();
            }
            return SchemaHelper.GetDescribe(m_local).getRelationshipName() + DOT
                    + SchemaHelper.GetDescribe(m_field).getName();
        }
    }
}