public class Discharge {
    
    list<Animal__c> lstAnimal {get;set;}
    public Animal__c objAnimal{get;set;}
    public Date Today { get { return Date.today(); }}
    public Discharge (ApexPages.StandardController controller)
    {
         lstAnimal = [select Id,
                      Designated_Handler__c,
                      Shelter_Location__c,
                      name, 
                      Animal_Name__c, 
                      type_of_animal__c, 
                      breed__c, 
                      gender__c, 
                      Current_Animal_Age_Estimate__c, 
                      Current_Animal_Age_Formatted__c,
                      Animal_Age__c,
                      Intake_Date_Time__c, 
                      Color__c,
                      Secondary_Color__c,
                      Current_Weight_in_kgs_Num__c,
                      Microchip_Number__c,
                      Assessment__c,
                      Recommendations__c,
                      Administered_Microchip_Number__c,
                      Photo_Document_Id__c,
                      Estimated_Date_of_Birth__c,
                      Feeding_Amount__c
                      FROM Animal__c 
                      WHERE Id = :ApexPages.currentPage().getparameters().get('Id')];
         if(lstAnimal.size()>0)
             objAnimal = lstAnimal[0];
    }
    
    public List<Animal_Exam_Sheet__c> examSheets{
        get{
            if (examSheets == null){
                examSheets = new List<Animal_Exam_Sheet__c>
                    ([SELECT Id, Exam_Date_Time__c, Assessment__c, Treatment_Instructions__c, Exam_Type__c,
                      Subjective2__c, //Picklist
                      Subjective__c, //Text
                      Mucus_Membrane_Capillary_Refill_Time2__c,
                      MM_CRT__c,
                      Dehydration_Degree__c,
                      Hydration__c,
                      HYD__c,
                      Ophthalmic_Eyes__c,
                      Ophthalmic_Eyes_Text__c,
                      Otic_Ears__c,
                      Otic_Ears_Notes__c,
                      Dental_Grade__c,
                      Oral2__c,
                      Oral__c,
                      Nose_Throat2__c,
                      Nose_Throat__c,
                      Peripheral_Lymph_Nodes2__c,
                      PLN__c,
                      Cardiac_Respiratory2__c,
                      Cardio_resp__c,
                      Abdomen__c,
                      ADB_GI__c,
                      Urogenital__c,
                      U_G__c,
                      Musculoskeletal2__c,
                      M_S__c,
                      Integument_External_Parasites2__c,
                      Integ_Parasites__c,
                      Neurologic2__c,
                      Neuro__c,
                      Pain2__c,
                      Pain__c,
                      Nails__c,
                      Nails2__c                                 
                     FROM Animal_Exam_Sheet__c
                     WHERE Animal__r.Id = :ApexPages.currentPage().getparameters().get('Id') AND Include_in_discharge__c = 'Yes'
                     ORDER BY Exam_Date_Time__c DESC]);
            }
            return examSheets;
        }
        set;
    }
    
    public List<Task> tsks{
        get{
            if (tsks == null){
                tsks = new List<Task> ([SELECT Subject, ActivityDate, Medication__r.Name, Dosage__c, Frequency_Of_Treatment__c, IsClosed,Description
                                      FROM Task 
                                      WHERE WhatId = :ApexPages.currentPage().getparameters().get('Id') AND Include_in_discharge__c = 'Yes'
                                       ORDER BY ActivityDate DESC 
                                       ]);
                
                
                
            }
            
            return tsks;
        }
        private set;
        
    }
    
    public List<Medical_Conditions__c> medCons{
        get{
            if (medCons == null){
                medCons = new List<Medical_Conditions__c> ([SELECT Id, Being_Treated__c, Date_Diagnosed__c, Date_Resolved__c, Details__c, Medical_Condition__c
                                                           FROM Medical_Conditions__c
                                                           WHERE Animal__r.Id = :ApexPages.currentPage().getparameters().get('Id') AND Discharge_Inclusion__c = 'Yes'
                                                           ORDER BY Date_Diagnosed__c DESC]);
            }
            return medCons;
        }
        private set;
    }
    
	public List<Diagnostic__c> diags{
        get{
            if (diags == null){
                diags = new List<Diagnostic__c> ([SELECT Id, Date__c, Test_Name__c, Test_Results__c, Test_Notes__c
                                                           FROM Diagnostic__c
                                                           WHERE Animal__r.Id = :ApexPages.currentPage().getparameters().get('Id') AND Include_in_discharge__c = 'Yes'
                                                 ORDER BY Date__c DESC]);
            }
            return diags;
        }
        private set;
    }
    
	public List<Vaccine_and_Preventative__c	> vaccs{
        get{
            if (vaccs == null){
                vaccs = new List<Vaccine_and_Preventative__c> ([SELECT Id, Vaccine_Preventative__r.Name, Date_Administered__c,Route__c,Notes__c
                                                           FROM Vaccine_and_Preventative__c	
                                                           WHERE Animal__r.Id = :ApexPages.currentPage().getparameters().get('Id')
                                                           ORDER BY Date_Administered__c DESC]);
            }
            return vaccs;
        }
        private set;
    }
    
    public List<Task> currentTasks{
        get{
            if (currentTasks == null){
                RecordType treatmentType = [SELECT ID FROM RecordType WHERE Name = 'Treatments' AND SObjectType = 'Task' LIMIT 1];
                ID treatmentID = treatmentType.ID;
                List<String> taskKeys = new List<String>();
                Set<String> recurringTaskIDs = new Set<String>();
                Map<String, Task> taskMap = new Map<String, Task>();
                for(Task animalTask : [SELECT ID, Subject, Medicine__c, ActivityDate, RecurrenceActivityId, WhatId, Medication__c, Medication__r.Name, 
                                       Dosage__c, Frequency_Of_Treatment__c, IsClosed, Description FROM Task
                                       WHERE WhatId = :ApexPages.currentPage().getparameters().get('Id') AND ActivityDate != null
                                       AND Status != 'Completed' AND RecordTypeId = :treatmentID ORDER BY ActivityDate asc]){
                    String taskKey = animalTask.RecurrenceActivityId;
                    System.debug('Recurrence ID: ' + taskKey);
                    if(animalTask.RecurrenceActivityId == null){
                    	taskKey = animalTask.ID;
                    }
                    if(taskKeys.contains(taskKey)){
                        recurringTaskIDs.add(taskKey);
                        /*Task recurringTask = taskMap.get(taskKey);
                        recurringTask.End_Date__c = animalTask.ActivityDate;
                        taskMap.put(taskKey, recurringTask);*/
                    } else {
                        Task currentTask = new Task();
                   		currentTask.Subject = animalTask.Subject;
                    	currentTask.ActivityDate = animalTask.ActivityDate;
                        currentTask.End_Date__c = animalTask.ActivityDate;
                        currentTask.Medication_Name__c = animalTask.Medication__r.Name;
                        currentTask.Medicine__c = animalTask.Medicine__c;
                        currentTask.Dosage__c = animalTask.Dosage__c;
                        currentTask.Frequency_Of_Treatment__c = animalTask.Frequency_Of_Treatment__c;
                        currentTask.Description = animalTask.Description;
                   		taskMap.put(taskKey, currentTask);
                    	taskKeys.add(taskKey);
                    }
                }
                for(String parentTaskID : recurringTaskIDs){
                    Task parentTask = [SELECT ID, RecurrenceStartDateOnly, RecurrenceEndDateOnly FROM Task WHERE ID = :parentTaskID LIMIT 1];
                    Task recurringTask = taskMap.get(parentTaskID);
                    recurringTask.ActivityDate = parentTask.RecurrenceStartDateOnly;
                    recurringTask.End_Date__c = parentTask.RecurrenceEndDateOnly;
                	if(recurringTask.End_Date__c <= TODAY){
                        taskMap.remove(parentTaskID);
                    } else {
                        taskMap.put(parentTaskID, recurringTask);
                    }
                }
                currentTasks = taskMap.values();
            }
            return currentTasks;
        }
        private set;
    }
    
    public List<Task> pastTasks{
        get{
            if (pastTasks == null){
                RecordType treatmentType = [SELECT ID FROM RecordType WHERE Name = 'Treatments' AND SObjectType = 'Task' LIMIT 1];
                ID treatmentID = treatmentType.ID;
                List<String> taskKeys = new List<String>();
                Set<String> recurringTaskIDs = new Set<String>();
                Map<String, Task> taskMap = new Map<String, Task>();
                for(Task animalTask : [SELECT ID, Subject, Medicine__c, ActivityDate, RecurrenceActivityId, WhatId, Medication__c, Medication__r.Name,
                                       Dosage__c, Frequency_Of_Treatment__c, IsClosed, Description FROM Task
                                       WHERE WhatId = :ApexPages.currentPage().getparameters().get('Id') AND ActivityDate != null
                                       AND Status = 'Completed' AND RecordTypeId = :treatmentID ORDER BY ActivityDate asc]){
                    String taskKey = animalTask.RecurrenceActivityId;
                    System.debug('Recurrence ID: ' + taskKey);
                    if(animalTask.RecurrenceActivityId == null){
                    	taskKey = animalTask.ID;
                    }
                    if(taskKeys.contains(taskKey)){
                        recurringTaskIDs.add(taskKey);
                        /*Task recurringTask = taskMap.get(taskKey);
                        recurringTask.End_Date__c = animalTask.ActivityDate;
                        taskMap.put(taskKey, recurringTask);*/
                    } else {
                        Task pastTask = new Task();
                   		pastTask.Subject = animalTask.Subject;
                    	pastTask.ActivityDate = animalTask.ActivityDate;
                        pastTask.End_Date__c = animalTask.ActivityDate;
                        pastTask.Medication_Name__c = animalTask.Medication__r.Name;
                        pastTask.Medicine__c = animalTask.Medicine__c;
                        pastTask.Dosage__c = animalTask.Dosage__c;
                        pastTask.Frequency_Of_Treatment__c = animalTask.Frequency_Of_Treatment__c;
                        pastTask.Description = animalTask.Description;
                   		taskMap.put(taskKey, pastTask);
                    	taskKeys.add(taskKey);
                    }
                }
                for(String parentTaskID : recurringTaskIDs){
                    Task parentTask = [SELECT ID, RecurrenceStartDateOnly, RecurrenceEndDateOnly FROM Task WHERE ID = :parentTaskID LIMIT 1];
                    Task recurringTask = taskMap.get(parentTaskID);
                    recurringTask.ActivityDate = parentTask.RecurrenceStartDateOnly;
                    recurringTask.End_Date__c = parentTask.RecurrenceEndDateOnly;
                    if(recurringTask.End_Date__c > TODAY){
                        taskMap.remove(parentTaskID);
                    } else {
                        taskMap.put(parentTaskID, recurringTask);
                    }
                }
                pastTasks = taskMap.values();
            }
            return pastTasks;
        }
        private set;
    }
        
}