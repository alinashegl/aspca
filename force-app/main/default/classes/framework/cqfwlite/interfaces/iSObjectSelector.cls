/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public interface iSObjectSelector {
    /**
 * The SObjectType covered by the Selector.
 * Value is set through the consuming class constructor by calling super(<SObject>.getSObjectType());
 * @return   SObjectType
 */
    SObjectType GetSObjectType();

    /**
     * The QueryFactory serving this Selector
     * @return   QueryFactory
     */
    iQueryFactory GetQueryFactory();

    /**
     * The default SObjectFields.
     * Must be implemented by the extending class.
     * @return   Set<Schema.SObjectField>
     */
    Set<Schema.SObjectField> GetDefaultFields();

    /**
     * The OrderBy definitions used by default.
     * Must be implemented by the extending class... implementation can return null.
     * @return   List<OrderBy>
     */
    List<iOrderBy> GetDefaultOrderBy();

    /**
     * Retrieves data by matching Id
     * @param  idSet The Id values to match
     * @return       List<SObject>
     */
    List<SObject> queryById(Set<Id> idSet);

    /**
     * Retrieves data by matching Name
     * @param  name  The name value to match
     * @return       List<SObject>
     */
    List<SObject> queryByName(String name);

    /**
     * Retrieves all records for the SObject
     * @return   List<SObject>
     */
    List<SObject> queryAll();

    /**
     * Retrieves all records for the SObject limited to a specified number of rows
     * @param  rowLimit The number of rows to retrieve
     * @return          List<SObject>
     */
    List<SObject> querySome(Integer rowLimit);
}