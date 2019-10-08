trigger sendOppToTwitter on Opportunity (after insert, after update) {
    for (Opportunity o : Trigger.new) {         
        if(o.StageName == 'Closed Won') {
    //this will be the name of your class and method, it doesn't have to be boomi   
            callToBoomi.postToBoomi(o.Id);         
        } else {
            System.debug('Stage != Closed Won');       
        }     
    }
}