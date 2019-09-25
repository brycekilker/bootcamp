global class OpportunityCloseDateBatch implements DataBase.Batchable<sObject> {

    String query;

    public OpportunityCloseDateBatch() {

        query = 'SELECT Id '
              + 'FROM Opportunity '
              + 'WHERE CloseDate < TODAY '
              + 'AND StageName != \'Closed Won\'' 
              + 'AND StageName != \'Closed Lost\'' ;
    }   

    global Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator(query);

    }

    global void execute(DataBase.BatchableContext BC, List<Opportunity> opptyList) {

        for (Opportunity opp : opptyList) {
            opp.StageName = 'Closed Lost';
        }

        update opptyList;

        System.debug('complete opptyList ' + opptyList);
    }

    global void finish(DataBase.BatchableContext BC) {

    }

}
