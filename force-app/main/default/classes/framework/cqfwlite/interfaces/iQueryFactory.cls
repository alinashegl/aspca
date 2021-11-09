/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public interface iQueryFactory {
    /**
 * Retrieves the SObjectType that this QueryFactory is generating SOQL on behalf of
 * @return  Schema.SObjectType
 */
    Schema.SObjectType GetUnderlyingType();

    /**
     * Fluently adds a field to the SELECT portion of the Query
     * @param  field    Schema.SObjectField The SObjectField to include in the Query
     * @return       The current instance of this QueryFactory
     */
    iQueryFactory WithField(Schema.SObjectField field);

    /**
     * Fluently adds a field to the SELECT portion of the Query
     * @param  fields   List<Schema.SObjectField>   The SObjectFields to include in the Query
     * @return          The current instance of this QueryFactory
     */
    iQueryFactory WithFields(List<Schema.SObjectField> fields);

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this QueryFactory
     */
    iQueryFactory WithRelatedField(Schema.SObjectField relatedField, Schema.SObjectField fieldOnRelation);

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField2    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this QueryFactory
     */
    iQueryFactory WithRelatedField(Schema.SObjectField relatedField
            , Schema.SObjectField relatedField2, Schema.SObjectField fieldOnRelation);

    /**
     * Fluently applies a field from a related SObject to include in the query
     * @param  relatedField     Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField2    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  relatedField3    Schema.SObjectField SObjectField on local SObject that holds the relationship
     * @param  fieldOnRelation  Schema.SObjectField SObjectField on a related SObject to include in the query
     * @return       The current instance of this QueryFactory
     */
    iQueryFactory WithRelatedField(Schema.SObjectField relatedField
            , Schema.SObjectField relatedField2, Schema.SObjectField relatedField3, Schema.SObjectField fieldOnRelation);

    /**
     * Fluently applies a Child query to include in the results
     * @param  child    QueryFactory A Child query to include in the results
     * @return       The current instance of this QueryFactory
     */
    iQueryFactory WithChildQuery(iQueryFactory child);

    /**
     * Fluently applies the Criteria used for the Query
     * @param  conditions Criteria   The Criteria to use to filter the Query
     * @return            The current instance of this QueryFactory
     */
    iQueryFactory WithCriteria(iCriteria conditions);

    /**
     * Fluently clears the existing sort order, if any
     * @return   The current instance of this QueryFactory
     */
    iQueryFactory ClearExistingOrder();

    /**
     * Fluently applies the sort order for the Query
     * @param  orderBy  OrderBy    Sort order for the resulting Query
     * @return         The current instance of this QueryFactory
     */
    iQueryFactory WithOrderBy(iOrderBy orderBy);

    /**
     * Fluently applies the sort order for the Query
     * @param  orderBys List<OrderBy>  Sort order for the resulting Query
     * @return         The current instance of this QueryFactory
     */
    iQueryFactory WithOrderBys(List<iOrderBy> orderBys);

    /**
     * Fluently adds a field to the sorting of the Query
     * @param  field    Schema.SObjectField The SObjectField to sort by Ascending
     * @return       The current instance of this QueryFactory
     */
    iQueryFactory OrderAscending(Schema.SObjectField field);

    /**
     * Fluently adds a field to the sorting of the Query
     * @param  field    Schema.SObjectField The SObjectField to sort by Descending
     * @return       The current instance of this QueryFactory
     */
    iQueryFactory OrderDescending(Schema.SObjectField field);

    /**
     * Fluently applies a Row Limit to the Query results
     * @param  rowLimit Integer The number of rows to retrieve
     * @return          The current instance of this QueryFactory
     */
    iQueryFactory WithRowLimit(Integer rowLimit);

    /**
     * Generates the SOQL statement used to perform the Query
     * @return   String
     */
    String GenerateSoql();

    /**
     * Generates the SOQL for nesting inside another query
     * @param   relateOn    String  relationship name to use instead of SObjectName
     * @return  String
     */
    String GenerateSoqlNested(String relateOn);

    /**
     * Executes the query produced by GenerateSoql() method
     * @return   List<SObject>
     */
    List<SObject> Execute();
}