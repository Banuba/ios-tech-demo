//
//  HairSkinColorsWrapper.m
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 15.03.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

#import "HairSkinColorsWrapper.h"
#import "BNBTechnology_HairSkin_Colors.h"

@implementation HairSkinColorsWrapper
{
    BNBTechnology_HairSkin_Colors *_customEffect;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _customEffect = new BNBTechnology_HairSkin_Colors();
    }
    return self;
}

- (void) setFeatureSet:(NSSet<NSNumber*>*)features {
    NSMutableSet<NSNumber*>* recognizerFeatures = [NSMutableSet new];
    for (NSNumber* featureWrapper in features) {
        ColorFeature feature = ColorFeature(featureWrapper.intValue);
        switch (feature) {
            case skinColor:
                [recognizerFeatures addObject: @(BNBFeatureIdFace)];
                break;
            case hairColor:
                [recognizerFeatures addObject: @(BNBFeatureIdHair)];
                break;
            default:
                break;
        }
    }
    
    _customEffect->setFeatures(recognizerFeatures);
}

- (BNBRNDModelDataSkinAndHairColor *)calculateColorsFromPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    _customEffect->RunModel(pixelBuffer);
    return _customEffect->getModelData();
        
}

- (void)dealloc {
    delete _customEffect;
}

@end
