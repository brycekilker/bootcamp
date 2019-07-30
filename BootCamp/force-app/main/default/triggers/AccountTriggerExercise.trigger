trigger AccountTriggerExercise on Account (before insert, before update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerExerciseHandler.beforeInsertMethod(Trigger.new);
    }
}