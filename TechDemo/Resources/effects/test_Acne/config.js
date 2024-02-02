bnb.scene.enableRecognizerFeature(bnb.FeatureID.FACE_ACNE);

let params = []
let uifitMode = 0;
let acneSize = 50;
let hasTouched = false;

function setFitMode(fitmode){
    uifitMode = fitmode
}

function onTouch(touches)  {
    hasTouched = true
    let surfW = bnb.scene.getSurfaceWidth();
    let surfH = bnb.scene.getSurfaceHeight();

    if(params.length == 0){
        params.push(new bnb.FeatureParameter(surfW, surfH, uifitMode, 0));
    }else{
        params[0] = new bnb.FeatureParameter(surfW, surfH, uifitMode, 0);
    }

    for (let i = 0; i < touches.length; i++) {
        bnb.log("X:" + touches[i].x + " Y:" + touches[i].y);
        params.push(new bnb.FeatureParameter(touches[i].x, touches[i].y, acneSize, acneSize))
    }
    bnb.scene.addFeatureParam(bnb.FeatureID.FACE_ACNE, params)
}

bnb.eventListener.on("onTouchesEnded", onTouch);

function onDataUpdate(param) {
    let acneMin = 50
    let acneMax = 150
    acneSize = acneMin + param * (acneMax - acneMin)
    bnb.log("Acne size: " + acneSize)
}

function GetTouchStatus() {
    return hasTouched;
}