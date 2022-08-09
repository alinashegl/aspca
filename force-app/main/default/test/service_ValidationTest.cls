@isTest 
private class service_ValidationTest {
    @isTest
    static void proccessRequest() {
        Map<String, Object> params = new Map<String, Object>{
            'apiName' => 'Contact',
            'recordId' => 'fakeRecordId'
        };

        Map<String, Object> request = new Map<String, Object>{
                'service' => Services.BehaviorEvaluation ,
                'action' => 'updateComments' ,
                'params' => params ,
                'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'apiName' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'values' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'recordId' ,
                                'type' => 'string' ,
                                'required' => true ,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        }
                } ,
                'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'item',
                                'type' => 'object',
                                'required' => true,
                                'apiName' => 'item',
                                'errors' => new Map<String, Object> {}
                        }
                }
        };

        Map<String, Object> response = new Map<String, Object>();

        test.startTest();
            Service_Validation.proccessRequest(request, response);
        test.stopTest();
    }

    @isTest 
    static void processRequestNoErrors(){
        Behavior_Evaluation__c be = TestDataFactory.createPuppyBehaviorEvaluation();
        Map<String, Object> params = new Map<String, Object>{
                'apiName' => 'Behavior_Evaluation__c',
                'recordId' => be.Id,
                'fieldName' => 'values'
            };
    
            Map<String, Object> request = new Map<String, Object>{
                    'service' => Services.BehaviorEvaluation ,
                    'action' => 'updateComments' ,
                    'params' => params ,
                    'fields' => new List<Map<String, Object>>{
                            new Map<String, Object>{
                                    'name' => 'apiName' ,
                                    'type' => 'string' ,
                                    'required' => true,
                                    'errors' => new Map<String, Object>{}
                            } ,
                            new Map<String, Object>{
                                    'name' => 'values' ,
                                    'type' => 'string' ,
                                    'required' => true,
                                    'defaultValue' => 'test',
                                    'errors' => new Map<String, Object>{}
                            } ,
                            new Map<String, Object>{
                                'name' => 'boolean' ,
                                'type' => 'boolean' ,
                                'required' => true,
                                'defaultValue' => false,
                                'operation' => '||',
                                'leftExpr' => 'left',
                                'rightExpr' => 'right',                                
                                'errors' => new Map<String, Object>{}
                                } ,
                        new Map<String, Object>{
                                'name' => 'decimal' ,
                                'type' => 'decimal' ,
                                'required' => true,
                                'defaultValue' => 4.0,
                                'errors' => new Map<String, Object>{}
                                } ,
                        new Map<String, Object>{
                                'name' => 'integer' ,
                                'type' => 'integer' ,
                                'required' => true,
                                'defaultValue' => 1,
                                'errors' => new Map<String, Object>{}
                                } ,
                        new Map<String, Object>{
                                'name' => 'date' ,
                                'type' => 'date' ,
                                'required' => true,
                                'operation' => '<',
                                'leftExpr' => 'left',
                                'rightExpr' => 'right',  
                                'defaultValue' => date.today(),
                                'errors' => new Map<String, Object>{}
                                } ,
                        new Map<String, Object>{
                                'name' => 'list' ,
                                'type' => 'list' ,
                                'required' => true,
                                'operation' => '||',
                                'leftExpr' => 'left',
                                'rightExpr' => 'right',  
                                'errors' => new Map<String, Object>{}
                                } ,
                            new Map<String, Object>{
                                    'name' => 'recordId' ,
                                    'type' => 'string' ,
                                    'required' => true ,
                                    'errors' => new Map<String, Object>{}
                            }
                    } ,
                    'response' => new List<Map<String, Object>>{
                            new Map<String, Object>{
                                    'name' => 'item',
                                    'type' => 'object',
                                    'required' => true,
                                    'apiName' => 'item',
                                    'errors' => new Map<String, Object> {}
                            }
                    }
            };
    
            Map<String, Object> response = new Map<String, Object>();
    
            test.startTest();
                Service_Validation.proccessRequest(request, response);
            test.stopTest();

    }
}