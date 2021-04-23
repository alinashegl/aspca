public with sharing class service_Validation
{
    public static void proccessRequest(Map<String, Object> config, Map<String, Object> response) {
            response.put('status', AppConfig.STATUS.get('error'));
            
            try {
                List<Map<String, String>> validationErrors = new List<Map<String, String>>();

                service_Request request = new service_Request();

                Map<String, Object> params = (Map<String, Object>)config.get('params');

                List<Map<String, Object>> fields = (List<Map<String, Object>>)config.get('fields');

                for(Map<String, Object> field : fields) {
                    String fieldName = (String)field.get('name');          
                    String fieldType = (String)field.get('type');                     
                    Object fieldValue = params.get(fieldName);   
                    Object defaultValue = field.get('defaultValue');

                    Boolean valid = true;

                    if((Boolean)field.get('required') == true || (fieldValue != null)) {
                        valid = isValidField(field, params);

                        if(valid == false && defaultValue != null) {                                                  
                            valid = true;
                            fieldValue = defaultValue;
                        }
                    } else {
                        if(defaultValue != null) {
                            fieldValue = defaultValue;
                        }
                    }
                    
                    if(valid) {
                        request.Parameters.put(fieldName, fieldValue);
                    } else {
                        System.debug('@@@ service_Validation:result: field:' + field);
                        updateValidationErrors(field, validationErrors);                    
                    }                               
                }

                if(validationErrors.size() > 0) {
                        response.put('errors', generateErrors(400, 'Invalid parameters', validationErrors));
                } else {
                        request.Parameters.put('action', (String)config.get('action'));

                        service_Response result = service_Controller.process((Services)config.get('service'), request);
                        System.debug('@@@ service_Validation:result: ' + result);
                        if(result.Errors.size() == 0 ) {
                            Map<String, Object> data = new Map<String, Object>();

                            List<Map<String, Object>> responseConfig = (List<Map<String, Object>>)config.get('response');

                            for(Map<String, Object> responseItem: responseConfig) {
                                String name = (String)responseItem.get('name');
                                String apiName = (String)responseItem.get('apiName');
                                data.put(apiName, result.Parameters.get(name));
                            }

                            response.put('data', data);
                            response.put('status', AppConfig.STATUS.get('success'));    
                        } else  {
                            response.put('errors', generateErrors(500, 'Internal Server Error', new List<String>(result.Errors)));
                        }
                }
            } catch(Exception e) {
                response.put('errors', generateErrors(500, 'Internal Server Error', new List<String>{e.getMessage()}));
            }
      }

      private static Boolean isValidField(Map<String, Object> field, Map<String, Object> params) {
            String fieldName = (String)field.get('name');                             
            Object fieldValue = params.get(fieldName);
            String fieldType = (String)field.get('type');
            Set<Object> availableTypes = (Set<Object>)field.get('availableTypes');
            String fieldOperation = (String)field.get('operation');
            Boolean valid = true;

            if(valid && availableTypes != null  && !availableTypes.contains(fieldValue)) {
                valid = false;
            }

            switch on fieldType {
                when 'boolean' {     
                    if(fieldOperation != null) {
                        if(fieldOperation == '||') {
                            String leftExpr = (String)field.get('leftExpr');
                            String rightExpr = (String)field.get('rightExpr');

                            Boolean fieldListLeft = (Boolean)params.get(leftExpr);
                            Boolean fieldListRigth = (Boolean)params.get(rightExpr);
                            
                            if(fieldListLeft == false && fieldListRigth == false) {
                                valid = false;
                            }
                        }
                    } else {     
                        if(fieldValue == null){
                            valid = false;  
                        } 
                    }
                }
                when 'decimal' {                    
                    if(fieldValue == null) {
                        valid = false;       
                    }
                }
                when 'integer' {      
                    if(fieldValue == null) {
                        valid = false;       
                    }                              
                }
                when 'string' {                
                    if(String.isBlank((String)(fieldValue))) {
                        valid = false;
                    }                               
                }     
                when 'date' {
                    if(fieldOperation != null) {
                        if(fieldOperation == '<') {
                            Date fieldStartDate = (Date)params.get((String)field.get('leftExpr'));
                            Date fieldEndDate = (Date)params.get((String)field.get('rightExpr'));  

                            if(fieldStartDate > fieldEndDate) {
                                valid = false;
                            }                           
                        }
                    } else {   
                        if(fieldValue == null) {
                            valid = false;
                        }                        
                    }
                }
                when 'list' {
                    if(fieldOperation != null) {
                        if(fieldOperation == '||') {
                            String leftExpr = (String)field.get('leftExpr');
                            String rightExpr = (String)field.get('rightExpr');

                            List<Object> fieldListLeft = (List<Object>)params.get(leftExpr);
                            List<Object> fieldListRigth = (List<Object>)params.get(rightExpr);
                            
                            if((fieldListLeft == null || fieldListLeft.size() == 0) && (fieldListRigth == null || fieldListRigth.size() == 0)) {
                                valid = false;
                            }
                        }
                    } else  {    
                            List<Object> fieldValueList = (List<Object>)(fieldValue);
                            if(fieldValueList == null) {
                                valid = false;                        
                            }
                    }
                }    
            }

            return valid;
      }

      private static void updateValidationErrors(Map<String, Object> field, List<Map<String,String>> validationErrors) {
            String errorType = 'ValidationError';
            String errorMessage = '';

            String fieldName = '';

            List<Object> parameters = null;

            if((String)field.get('operation') != null) {
                parameters = new List<Object> {
                    (String)field.get('leftExpr'), 
                    (String)field.get('rightExpr')
                };                
                //(String)field.get('leftExpr') + ' or ' + (String)field.get('rightExpr');
            } else {
                fieldName = (String)field.get('name');

                parameters = new List<Object> {
                    fieldName
                };
            }

            Map<String, Object> errors = (Map<String, Object>)field.get('errors');

            if(errors.containsKey(errorType)) {
                  Map<String, String> error = (Map<String, String>)errors.get(errorType);
                  errorMessage = String.format(error.get('message'), parameters);
            }

            if(String.isBlank(errorMessage)) {
                errorMessage = fieldName + ' is not valid';
            }

            validationErrors.add(new Map<String, String>{
                  'type' => errorType,
                  'field' => fieldName,
                  'message' => errorMessage
            });
      }

      private static Map<String,Object> generateErrors(Integer code, String message, Object listErrors) {
            Map<String,Object> error = new Map<String,Object> {
                  'code' => code,
                  'message' => message,
                  'list' => listErrors
            };

            return error;
      }


    /**
     * Test a String to see if it is a valid SFDC ID
     * @param  newId The ID to test.
     * @param  t The Type of the sObject to compare against
     * @return Returns true if the ID is valid, false if it is not.
     */
    public static Boolean isValidSalesforceId(String newId, System.Type t) {
        //isValidSalesforceID(theId, Account.class)
        try {
            if (Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(newId).matches()) {
                Id id = newId;
                sObject sObj = (sObject)t.newInstance();
                sObj.Id = id;

                return true;
            }
        } catch (Exception e) {
            // StringException, TypeException
        }

        return false;
    }
}