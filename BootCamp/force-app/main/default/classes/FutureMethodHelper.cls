public with sharing class FutureMethodHelper {

    @Future
    public static void anotherFutureMethod(Set<Id> opptyIds) {

        System.debug('in anotherFutureMethod');
        List<Opportunity> opptyList = [SELECT Id, Name FROM Opportunity WHERE Id IN : opptyIds];

        for(Opportunity oppty : opptyList) {
            oppty.Name = oppty.Name + ' Future';
        }
    }
}
