trigger OpportunityTrigger on Opportunity (before update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        OpportunityTriggerHandler.beforeUpdateMethod(Trigger.new);
    }

}

//What needs to happen here
// If the Opp is updated we need to go into the related quote and update the address ??All quotes??
//from the quote side ill check if its primary
//Create a check to make sure that you don't create an infinite loop between updating opportunity and quote
