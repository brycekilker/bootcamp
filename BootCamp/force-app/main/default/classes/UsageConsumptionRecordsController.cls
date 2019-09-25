public with sharing class UsageConsumptionRecordsController {
    public Id recordId {get; set;}
	public Usage_Summary__c currentUsageSummary {get; set;}
	public Usage_Consumption__c newUsageConsumptionRecord {get; set;}
	public List<Usage_Consumption__c> usageConsumptionList {get; set;}
	public Boolean UsageConsumptionExists {get; set;}

	public UsageConsumptionRecordsController() {
		// haveUsageSummary = false;
        // recordId = ApexPages.currentPage().getParameters().get('id');

        // if (recordId.getSobjectType() == Order.sObjectType) {

        // } else if (recordId.getSobjectType() == Usage_Summary__c.sObjectType) {
		// 	getUsageSummary();
		// 	newUsageConsumptionRecord = new Usage_Consumption__c(Loaded_Date__c = Date.Today());
		// 	haveUsageSummary= true;
		// }

		recordId = ApexPages.currentPage().getParameters().get('id');
		if (recordId != null) {
		    UsageConsumptionExists = false;
			getUsageSummary();
			getConsumptionRecords();
			System.debug('is this the right ID? ' + currentUsageSummary.Id);
			newUsageConsumptionRecord = new Usage_Consumption__c(Loaded_Date__c = Date.Today(), Usage_Summary__c=recordId);
        }
	}

	public void createOrEditUsageConsumptionRecord() {
		    if (newUsageConsumptionRecord.Id == null) {
            insert newUsageConsumptionRecord;
        } else {
            update newUsageConsumptionRecord;
        }
		System.debug('can You read this?');
	}

	public void getUsageSummary() {
		currentUsageSummary = [
			SELECT Id, Name, Account__c, End_Date__c, Order__c, Minimum_Paid__c,
			 Order_Product__c, Start_Date__c, Total_Charge__c, Usage_Period__c, Grand_Total_Usage__c
			FROM Usage_Summary__c
			WHERE Id = :recordId
		];
		System.debug('im not crazy ' + recordId);
    	getConsumptionRecords();

	}

	public void getConsumptionRecords() {
		List<Usage_Consumption__c> usageConsumptionList = [
            SELECT Id, Usage_Summary__c, Usage_Amount__c
            FROM Usage_Consumption__c
			WHERE Usage_Summary__c = :currentUsageSummary.Id
			LIMIT 10
        ];

		if (usageConsumptionList.size() > 0){
			UsageConsumptionExists = true;
		}

		System.debug('is thsi hitting? CL ' + usageConsumptionList);
	}
}