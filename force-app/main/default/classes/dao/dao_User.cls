/**
 * Class description
 *
 * @author Lamar Barnett
 * 
 */
public with sharing class dao_User extends sql_Dao {
    public dao_User() {
        setSObject(User.sObjectType);

        addField(User.Id);
        addField(User.Name);
    }

    public User findOne(String id) {
          List<User> users = getWhere(sql_Criteria.Equals(User.Id, id));

          if(users.isEmpty()) {
               return null;
          }

          return users[0];
    }


    public List<User> findAll() {
       Set<String> standardUsers = new Set<String> {//TODO:review standart | all?
           'Automated Process',
           'Data.com Clean',
           'Integration User',
           'Security User',
           'Chatter Expert'
       };

       return (List<User>)getWhere(sql_Criteria.ValueNotIn(User.Name, standardUsers));
    }

    public List<User> findAllByIds(Set<String> ids) {
        if(ids == null || ids.isEmpty()) {
            return new List<User>();
        }

        return (List<User>)getWhere(sql_Criteria.ValueIn(User.Id, ids));
    }

}