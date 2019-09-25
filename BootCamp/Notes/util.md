## create opportunities 

 List<Opportunity> oppsToAdd = new List<Opportunity>();
 Date minDate = Date.Today().addDays(-730);
 Date maxDate = Date.Today().addDays(730);
 public Date randomDate(Date minDate, Date maxDate){
 Integer rangeSize = minDate.daysBetween(maxDate) + 1;
 Decimal daysToAdd = rangeSize * math.Random();
 Date result = minDate.addDays(daysToAdd.intValue());
 return result;
 }
 for(Integer i=0;i<5000;i++){
 Opportunity opp = new Opportunity();
 opp.Name = 'Batchable Opp '+i;
 opp.CloseDate = randomDate(minDate,maxDate);
 opp.StageName = 'Prospecting';
 oppsToAdd.add(opp);
 }
 insert oppsToAdd;
 System.debug(oppsToAdd.size()+' Opportunities created');



 ////Different one
List<Opportunity> opptyList = new List<Opportunity>();
for (Integer i = 0; i < 10; i++) {
 Opportunity newOpp = new Opportunity();
 newOpp.name = 'Opp ' + i;
 newOpp.StageName = 'Needs Analysis';
 newOpp.CloseDate = generateDate();
 opptyList.add(newOpp);
}
insert opptyList;
public Date generateDate(){
 System.debug(Math.max(Math.floor(Math.random()*100), 12));
 Integer month = Integer.valueOf(Math.min(Math.floor(Math.random()*100), 12));
 Integer day = Integer.valueOf(Math.min(Math.floor(Math.random()*100), 31));
 Integer yearPicker = Integer.valueOf(Math.floor(Math.random()*100));
 Integer year = 2017;
 if (yearPicker > 80) {
 year = 2021;
 } else if (yearPicker > 60) {
 year = 2020;
 } else if (yearPicker > 40) {
 year = 2019;
 } else if (yearPicker > 20) {
 year = 2018;
 }
 System.debug(Date.newInstance(year, month, day));
 return Date.newInstance(year, month, day);
}



## Optimized Apex batches and schedules

- overload contructors during testing to not affect all of your sandbox accounts
- add conditionals to just run code on a specific sObject
