/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public without sharing class OrderBy implements iOrderBy{
    @TestVisible private static final String ORDER_ASC = ' ASC';
    @TestVisible private static final String ORDER_DESC = ' DESC';

    private String m_OrderBy { get; set; }

    /**
     * Execute generation of the ORDER BY statement as a String
     * @return      String
     */
    public String ForSoql() {
        return m_OrderBy;
    }

    /**
     * Generates ORDER BY ASC
     * @param   field   Schema.SObjectField   The field to sort by
     * @return      A new instance of OrderBy
     */
    public static OrderBy Ascending(Schema.SObjectField field) {
        return new OrderBy(field, ORDER_ASC);
    }

    /**
     * Generates ORDER BY DESC
     * @param   field   Schema.SObjectField   The field to sort by
     * @return      A new instance of OrderBy
     */
    public static OrderBy Descending(Schema.SObjectField field) {
        return new OrderBy(field, ORDER_DESC);
    }

    private OrderBy(Schema.SObjectField field, String direction) {
        m_OrderBy = SchemaHelper.GetDescribe(field).getName() + direction;
    }
}