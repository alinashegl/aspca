/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_User extends service_Base {
    public override void process(service_Request request, service_Response response) {
        if(request.Parameters.containsKey('action')) {
            switch on (String)request.Parameters.get('action') {
                when 'getUserById' {//TODO: rename
                    getUserById(request, response);
                }
                when 'getUsers' {
                    getUsers(request, response);//TODO: rename to getList
                }           
            }
        }
    }

    public void getUserById(service_Request request, service_Response response) {
        Map<String, String> userInfo = null;

        String userId = (String)request.Parameters.get('userId');//TODO:rename to id

        dao_User daoUser = new dao_User();
        User userData = daoUser.findOne(userId);

        if(userData != null) {
            userInfo = new Map<String, String>{
                'id' => userData.Id,
                'name' => userData.Name
            };
        }

        response.Parameters.put('user', userInfo);
    }

    public void getUsers(service_Request request, service_Response response) {
        dao_User daoUser = new dao_User();
        List<User> users = daoUser.findAll();

        response.Parameters.put('list', users);
    }
}