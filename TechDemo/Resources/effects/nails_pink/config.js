bnb.scene.enableRecognizerFeature(bnb.FeatureID.NAILS);

let color = new bnb.FeatureParameter(0.78, 0.3, 0.56, 1.0);
let gloss = new bnb.FeatureParameter(30, 0, 0, 0);

bnb.scene.addFeatureParam(bnb.FeatureID.NAILS, [color,gloss])
