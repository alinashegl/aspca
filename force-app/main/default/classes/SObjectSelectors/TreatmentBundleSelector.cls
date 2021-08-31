/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class TreatmentBundleSelector extends SObjectSelector{
    public TreatmentBundleSelector() {
        super(Pricebook2.SObjectType);
    }
    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField> {
                Pricebook2.Name,
                Pricebook2.CreatedById ,
                Pricebook2.CreatedDate ,
                Pricebook2.Description ,
                Pricebook2.LastModifiedById ,
                Pricebook2.Id ,
                Pricebook2.IsActive
        };
    }
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                OrderBy.Ascending(Pricebook2.Name) ,
                OrderBy.Ascending(Pricebook2.Id)
        };
    }
    public List<Pricebook2> GetById(Set<Id> ids) {
        return queryById(ids);
    }

    public List<Pricebook2> GetByName(String name) {
        return queryByName(name);
    }

}