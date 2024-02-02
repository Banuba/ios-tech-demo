
bnb.scene.enableRecognizerFeature(bnb.FeatureID.GLASSES);


function onDataUpdate(){
    return bnb.scene.getTriggerStatus(bnb.TriggerType.GLASSES_STATUS) == bnb.TriggerStatusType.EXISTS;
}