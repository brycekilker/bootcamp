public with sharing class OpportunityQueueable2 implements Queueable {
    
    public List<Opportunity> opptyList; 

 
    public OpportunityQueueable2(List<Opportunity> opptyList) {
        this.opptyList = opptyList;
    }
    public void execute(QueueableContext context) {
        for (Opportunity opp : opptyList) {
            opp.Description = 'This is the description from 2nd queueable job';
            System.debug('we hit the second chain!!' + opp );
        }
        update opptyList;
        
    }
}
