public with sharing class OpportunityQueueable1 implements Queueable {
   
    public List<Opportunity> opptyList; 
   
    public OpportunityQueueable1(List<Opportunity> opptyList) {
        this.opptyList = opptyList;
    }

    public void execute(QueueableContext context) {
        
        for(Opportunity opp : opptyList ) {
            opp.Amount = 100000;
        }

        update opptyList;
        System.enqueueJob(new OpportunityQueueable2(opptyList));

    }
}


//List<Opportunties> opptyList = [SELECT Id FROM Opportunity LIMIT 5];

//Queued this in the debug console
// OpportunityQueueable1 newJob = new OpportunityQueueable1(opptyList);
// Id jobId = System.enqueueJob(newJob);

// System.debug('jobId: ' + jobId);