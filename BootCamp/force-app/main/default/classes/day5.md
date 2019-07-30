## Triggers
- Id recordId = '00Q3i000001IUKmEAO';

Lead leadRecord = [SELECT Id FROM Lead WHERE Id = :recordId LIMIT 1];
delete leadRecord;

-REMEMBER ALL ROWS WHEN UNDELETING

## Apex Classes
- handler and helper are often synonomous
- handlers pull all the logic under one trigger