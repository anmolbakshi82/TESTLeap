public with sharing class VfReportsDashboards 
{
    public String ownerID { public get; public set; }

     //added a new comment in master again
     //adding a new comment 
    
     // Opportunity Pipeline Report
    public countRecord[] countRecords { get; set; }
    public countRecord[] countAgg { get; set; }
    public countRecord[] countProspect { get; set; }
    public countRecord[] countTentative { get; set; }
    public countRecord[] countDefinite { get; set; }
    public countRecord[] countConsumed { get; set; }
    public countRecord[] countCanDef { get; set; }
    public countRecord[] countCancelled { get; set; }
    public countRecord[] countTurnedDown { get; set; }
    public countRecord[] countLead { get; set; }
    public countRecord[] countOpportunity { get; set; }
    public countRecord[] countTotalPipeLine { get; set; }
    public countRecord[] totalFactored { get; set; }
    
/*
    // Activity Report
    public countRecordA[] countAggA { get; set; }
    public countRecordA[] countRecordsA { get; set; }
*/ 
    public countRecord[] countTasks { get; set; }
    public countRecord[] countActivities { get; set; }
    public countRecord[] countActivitiesLW { get; set; }
    public countRecord[] countActivitiesLM { get; set; }
    public countRecord[] countContact { get; set; }
    public countRecord[] countAccount { get; set; }
    

    public VfReportsDashboards() 
    {
        // Get current user's userId
        String curUserId = system.UserInfo.getUserId();
        Set<Id> subRolesSet = getUsersBelowInHierarchy(curUserId);
        
        Set<Id> selectUId = new Set<Id>();
        List<String> stgName = new List<String>();
        
        //String currentUserRoleId = userInfo.getUserRoleId();
        //currentRoleIds.add(currentUserRoleId);
                
        System.debug('$$$ subRolesSet size: ' + subRolesSet.size());
        
        for(Id uId : subRolesSet)
        {
   
               
                selectUId.add(uId);
           
        }
        // Add Current User ID as well
        selectUId.add(curUserId);
    //Map the user Id and get all the pictures 
         map<Id, User> mapUserInfo = new map<Id, User>([Select Id, SmallPhotoUrl from user where Id IN: selectUId]);
   // Opportunity Pipeline Report
        AggregateResult[] oppAmountResults = [Select Owner.Name oName, OwnerId oId,sum(Amount) OppAmt, StageName, OwnerId From Opportunity group by StageName, OwnerId, Owner.Name order by OwnerId, StageName,Owner.Name];    
        AggregateResult[] LeadResults = [SELECT Owner.Name oName, OwnerId oId, count(Id) countLead FROM Lead WHERE CreatedById IN :selectUId and CreatedDate = LAST_WEEK group by Owner.Name, OwnerId order by Owner.Name];
        AggregateResult[] OpportunityResults = [SELECT Owner.Name oName, OwnerId oId, count(Id) countOpportunity FROM Opportunity WHERE CreatedById IN :selectUId and CreatedDate = LAST_WEEK group by Owner.Name, OwnerId order by Owner.Name];
  // Activity Report
        AggregateResult[] eventResults = [SELECT Owner.Name oName, OwnerId oId, count(Id) countActivities FROM Event WHERE CreatedById IN :selectUId and CreatedDate = THIS_WEEK group by Owner.Name, OwnerId order by Owner.Name ];
        AggregateResult[] taskResults = [SELECT Owner.Name oName, OwnerId oId, count(Id) countActivities FROM Task WHERE CreatedById IN :selectUId and CreatedDate = THIS_WEEK group by Owner.Name, OwnerId order by Owner.Name];
        
        AggregateResult[] eventResultsLW = [SELECT Owner.Name oName, OwnerId oId, count(Id) countActivities FROM Event WHERE CreatedDate = LAST_WEEK group by Owner.Name, OwnerId order by Owner.Name ];
        AggregateResult[] taskResultsLW = [SELECT Owner.Name oName, OwnerId oId, count(Id) countActivitiesLW FROM Task WHERE CreatedById IN :selectUId and CreatedDate = LAST_WEEK group by Owner.Name, OwnerId order by Owner.Name];
        
        AggregateResult[] eventResultsLM = [SELECT Owner.Name oName, OwnerId oId, count(Id) countActivities FROM Event WHERE CreatedDate = LAST_MONTH  group by Owner.Name, OwnerId order by Owner.Name ];
        AggregateResult[] taskResultsLM = [SELECT Owner.Name oName, OwnerId oId, count(Id) countActivitiesLM FROM Task WHERE CreatedById IN :selectUId and CreatedDate = THIS_MONTH  group by Owner.Name, OwnerId order by Owner.Name];
     
        AggregateResult[] contactResults = [SELECT Owner.Name oName, OwnerId oId, count(Id) countContact FROM Contact WHERE CreatedById IN :selectUId and CreatedDate = LAST_WEEK group by Owner.Name, OwnerId order by Owner.Name];
        AggregateResult[] accountResults = [SELECT Owner.Name oName, OwnerId oId, count(Id) countAccount FROM Account WHERE CreatedById IN :selectUId and CreatedDate = LAST_WEEK group by Owner.Name, OwnerId order by Owner.Name];
   
   
 
 // Opportunity Pipeline Report
       
        countAgg = new list<countRecord>();
        countRecords = new List<countRecord>(); 

        
        Double countPros;
        Double countTent;
        Double countDef; 
        Double countConsu;
        Double countCD;
        Double countCan;
        Double countTD;
        String countProsS;
        String countTentS;
        String countDefS; 
        String countConsuS;
        String countCDS;
        String countCanS;
        String countTDS;
        Integer countLe; 
        Integer countOppty;
        Double TotalPipe;
        String TotalPipeS;
        String userName;
        Double TotalFac;
        String TotalFacS;
        String photoURL;
        
        List<String> args = new String[]{'0','number','###,###,##0.00'};

        
  
       
        
// Activity Report
        
//        countRecordsA = new List<countRecordA>();
        countTasks = new list<countRecord>();
        countActivities = new list<countRecord>();
        countActivitiesLW = new list<countRecord>();
        countActivitiesLM = new list<countRecord>();
        Integer countActs;
        Integer countActsE;
        Integer countActsLW;
        Integer countActsLWE;
        Integer countActsLM; 
        Integer countActsLME;
        Integer countContacts;
        Integer countAccounts;
        Double tTW;
        Double tLW;
        Double tLM;
        
        
        Map<Id, AggregateResult> mapAR = new Map<Id, AggregateResult>();
  
        list<AggregateResult> allAggrResults = new list<AggregateResult>();
        allAggrResults.addAll(taskResults);
        allAggrResults.addAll(taskResultsLW);
        allAggrResults.addAll(taskResultsLM);

  // Opportunity Pipeline Report       
        for(Id thisUserId : selectUId)
        {
            countPros = 0;
            countTent = 0;
            countDef = 0; 
            countConsu = 0;
            countCD = 0;
            countCan = 0;
            countTD = 0;
            countLe = 0; 
            countOppty = 0;
            TotalPipe= 0;
            TotalFac= 0;
             photoURL = mapUserInfo.get(thisUserId).SmallPhotoUrl;        
            for (AggregateResult arT : oppAmountResults) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    userName = (String)arT.get('oName');
                    if(arT.get('StageName') == 'Prospect')
                    {       
                        countPros = ((Double)arT.get('OppAmt'));
                        countProsS = String.format(countPros.format(), args);
                        
                    }
                    
                    if(arT.get('StageName') == 'Tentative')
                    {       
                        countTent = ((Double)arT.get('OppAmt'));
                        countTentS = String.format(countTent.format(), args);
                        
                    }
                    
                    if(arT.get('StageName') == 'Definite')
                    {       
                        countDef = ((Double)arT.get('OppAmt'));
                        countDefS = String.format(countDef.format(), args);
                        
                    }
                    
                    if(arT.get('StageName') == 'Consumed')
                    {       
                        countConsu = ((Double)arT.get('OppAmt'));
                        countConsuS = String.format(countConsu.format(), args);
                        
                    }
                    
                    if(arT.get('StageName') == 'Cancelled Definite')
                    {       
                        countCD = ((Double)arT.get('OppAmt'));
                        countCDS = String.format(countCD.format(), args);
                        
                    }
                    
                    if(arT.get('StageName') == 'Cancelled')
                    {       
                        countCan = ((Double)arT.get('OppAmt'));
                        countCanS = String.format(countCan.format(), args);
                        
                    }
                    
                    if(arT.get('StageName') == 'TurnedDown')
                    {       
                        countTD = ((Double)arT.get('OppAmt'));
                        countTDS = String.format(countTD.format(), args);
                        
                    }
                }
            }   
                          
            for (AggregateResult arT : LeadResults) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countLe = (Integer)arT.get('countLead');
                    userName = (String)arT.get('oName');
                }
            } 
            for (AggregateResult arT : OpportunityResults) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countOppty = (Integer)arT.get('countOpportunity');
                    userName = (String)arT.get('oName');
                }
            } 
            TotalPipe = countPros + countTent + countDef + countConsu ;
            TotalPipeS = String.format(TotalPipe.format(), args);
            TotalFac = (countPros*0.1) + (countTent*0.7) + (countDef*0.8) + countConsu ;
            TotalFacS = String.format(TotalFac.format(), args);
        
            if ((countPros > 0) || (countTent > 0) || (countDef > 0) || (countConsu > 0) || (countCD > 0 ) || (countCan > 0 ) || (countTD  > 0 ) || (countLe > 0) || (countOppty > 0 ))
            {
                countAgg.add(new countRecord(userName, thisUserId, countProsS, countTentS, countDefS, countConsuS, countCDS,countCanS,countTDS,countLe,
                                countOppty,TotalPipeS,TotalFacS,photoURL));
            }

        }
        
        countRecords.addAll(countAgg);
        
        // Activity Report
        
        for(Id thisUserId : selectUId)
        {
            countActs = 0;
            countActsE = 0;
            countActsLW = 0;
            countActsLWE = 0;
            countActsLM = 0;
            countActsLME = 0;
            countContacts = 0;
            countAccounts = 0;
            tTW = 0;
            tLW = 0;
            tLM = 0;
            
            photoURL = mapUserInfo.get(thisUserId).SmallPhotoUrl;
                        
            System.debug('$$$ Print UserID: ' + thisUserId);
            
            for (AggregateResult arT : taskResults) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countActs = (Integer)arT.get('countActivities');
                    tTW = (countActs * 100)/30 ;
                    userName = (String)arT.get('oName');
                }
            }   
            
                  for (AggregateResult arT : eventResults) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countActsE = (Integer)arT.get('countActivities');

                }
            }  
            
            countActs = countActs+countActsE;

            for (AggregateResult arT : taskResultsLW) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countActsLW = (Integer)arT.get('countActivitiesLW');
                    tLW = (countActsLW * 100)/30;
                    userName = (String)arT.get('oName');
                }
            }   

            for (AggregateResult arT : eventResultsLW) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countActsLWE = (Integer)arT.get('countActivities');

                }
            }     

                countActsLW = countActsLW + countActsLWE;

            for (AggregateResult arT : taskResultsLM) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countActsLM = (Integer)arT.get('countActivitiesLM');
                    tLM = (countActsLM * 100)/70;
                    userName = (String)arT.get('oName');
                    //countTasks.add(new countRecord(arT, thisUserId, countActs, countActsLW, countActsLM));
                }
            } 

               for (AggregateResult arT : eventResultsLM) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countActsLME = (Integer)arT.get('countActivities');

                }
            } 
                countActsLM = countActsLM + countActsLME;

            for (AggregateResult arT : contactResults) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countContacts = (Integer)arT.get('countContact');
                    userName = (String)arT.get('oName');
                }
            }  
            for (AggregateResult arT : accountResults) 
            {
                if(thisUserId == arT.get('oId'))
                {
                    countAccounts = (Integer)arT.get('countAccount');
                    userName = (String)arT.get('oName');
                }
            }    
            
            
            if ((countActs > 0) || (countActsLW > 0) || (countActsLM > 0) || (countContacts > 0) || (countAccounts > 0 ))
            {
                countTasks.add(new countRecord(userName, thisUserId, countActs, countActsLW, countActsLM, tTW, tLW, tLM,countContacts,countAccounts,photoURL));
            }

        }
        countRecords.addAll(countTasks);
 
    }

    // wrapper class
    
     // Opportunity Pipeline Report 
    public class countRecord 
    {
    
        public String countProspect { get; private set;}
        public String countTentative { get; private set;}                
        public String countDefinite { get; private set;}
        public String countConsumed { get; private set;}
        public String countCanDef { get; private set;}
        public String countCancelled { get; private set;}                
        public String countTurnedDown { get; private set;}
        public Integer countLead { get; private set;}
        public Integer countOpportunity { get; private set;}
        public String countTotalPipeLine { get; set;}
        public String Id { get; private set;}
        public String ownerName {get; private set;}
        public String totalFactored{get; set;}
        public String photoURL {get; private set;}

        public Integer countActivities { get; private set;}
        public double target{get; set;}
        public double targetLW{get; set;}
        public double targetLM{get; set;}
        public Integer countContact { get; private set;}                
        public Integer countAccount { get; private set;}
        public Integer countActivitiesLW { get; private set;}
        public Integer countActivitiesLM { get; private set;}

        public countRecord(String userName, Id userId, String countP, String countT, String countD, String countC,String countCD,String countCa, 
                            String countTu, Integer countLea, Integer countOp, String countTP, String totalF, String phURL) 
        {
            Id = userId;
            ownerName = userName;
            countProspect = countP;
            countTentative = countT;              
            countDefinite = countD; 
            countConsumed = countC;
            countCanDef = countCD;
            countCancelled  = countCa;               
            countTurnedDown = countTu;
            countLead = countLea;
            countOpportunity = countOp;
            countTotalPipeLine = countTP;
            totalFactored = totalF;
            photoURL = phURL;
        }
        
        public countRecord(String userName, Id userId, Integer countActs, Integer countActsLW, Integer countActsLM,
                            double targetTW, double tarLW, double tarLM, Integer countCon,Integer countAcc, String phURL) 
        {
            Id = userId;
            ownerName = userName;
            //ownerName = (String) ar.get('oName');
            countActivities = countActs;
            countActivitiesLW = countActsLW;
            countActivitiesLM = countActsLM;
            target = targetTW;
            targetLW = tarLW;
            targetLM = tarLM;
            countContact = countCon;
            countAccount = countAcc;
            photoURL = phURL;
        }
    }
    
 /*
    // Activity Report
    
        public class countRecordA 
    {
        public Integer countActivities { get; private set;}
        public String Id { get; private set;}
        public String ownerName {get; private set;}
        public double target{get; set;}
        public double targetLW{get; set;}
        public double targetLM{get; set;}
        public Integer countContact { get; private set;}                
        public Integer countAccount { get; private set;}
        public Integer countActivitiesLW { get; private set;}
        public Integer countActivitiesLM { get; private set;}
        public String photoURL {get; private set;}

        public countRecordA(String userName, Id userId, Integer countActs, Integer countActsLW, Integer countActsLM,
                            double targetTW, double tarLW, double tarLM, Integer countCon,Integer countAcc, String phURL) 
        {
            Id = userId;
            ownerName = userName;
            //ownerName = (String) ar.get('oName');
            countActivities = countActs;
            countActivitiesLW = countActsLW;
            countActivitiesLM = countActsLM;
            target = targetTW;
            targetLW = tarLW;
            targetLM = tarLM;
            countContact = countCon;
            countAccount = countAcc;
            photoURL = phURL;
            
        }
    }
*/


    public pageReference loadOwner()
    {
        String hn = ApexPages.currentPage().getHeaders().get('Host');
        String l_url = 'https://' + hn + '/' + ownerID;     
        
        pageReference pageref = new pageReference(l_url);
        pageref.setRedirect(true);

        return pageref;
    }
    
    public static Set<ID> getUsersBelowInHierarchy(Id userId) 
    {
        // get requested user's role
        Id roleId = [select UserRoleId from User where Id = :userId].UserRoleId;
        
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        
        // get all of the ids for the users in those roles
        //Set<Id> userIds = new Set<Id>([Select Id  From User where UserRoleId IN :allSubRoleIds]);
        Map<Id,User> users = new Map<Id, User>([Select Id, Name, IsActive From User where IsActive = true and UserRoleId IN :allSubRoleIds]);
        
        // return the ids as a set so you can do what you want with them
        return users.keySet();
    }
    
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) 
    {
        Set<ID> currentRoleIds = new Set<ID>();
    
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null])
        {
            currentRoleIds.add(userRole.Id);    
        }
        // go fetch some more rolls within the roles 
        if(currentRoleIds.size() > 0)
        {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
  }
    
    

}