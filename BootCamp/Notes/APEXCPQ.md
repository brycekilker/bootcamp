-LOOK FOR IT ON THE TEAMS CHANNEL/SOFTWAREENGINEERING/GENERAL/FILES/PRESENTATION/APEXFORSALESFORCECPQ

## Austins Presention 8/8/19
- QLE opperates outside the bounds of normal SF interactions
    - ie: QLE is tricky to hit with triggers
    - heavy dml restictions on quotes and qle
- DML on QL causes a background queable process to invoke the pricing engine
    - locks the record while that's running and gets very expensive
    - possible recurrsive cycle
- can't make HTTP callouts from a Triggger
    - this is a restriction from SF for time
    - needs to be in an asyc callout like queable or batch
- Ordered checkbox creates order and order lines
- Can only enque one queueable job per transaction
    - then add a chain if you need to call another job
- SFBILLING also creates revenue schedules in a queable job 
 - You want 'contract in Foreground' set to true if you're doing a high volume job
 - *****Austin has a nnice slide of does and do-nots for QuoteLine manipulation
 - understand the Lifecycle for CPQ
 - If you are making a quote trigger, if any of the fields are calculating fields they will start a queable/calculable job
 - before insert/update tirggers on QLE won't trigger another DML - safer to use
    - but you won't have ID's
- you can disable or renable triggers programatically in the code
- QLE lines are related by the 'required by' field. this looks up to the quote.
- trigger calls each level of your bundle and works its way down
    - so if you have a 3 tier bundle its calling the trigger 3 times
    - this can get expensive

-FIND the SF CPQ plugin on VS code for these projects

- Quoteline has hooks that run similar to triggers, but you can get very granular when they fire

- look up quote calculator configuration

- Read docs on Salesforce CPQ API

- inserting QL's directly gets crazy messy and complex.

- Austin has links to resources - check austin's medium page.

-LOOK FOR IT ON THE TEAMS CHANNEL/SOFTWAREENGINEERING/GENERAL/FILES/PRESENTATION/APEXFORSALESFORCECPQ