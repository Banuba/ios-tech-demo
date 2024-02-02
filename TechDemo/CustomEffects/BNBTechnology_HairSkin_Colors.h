//
//  BNBTechnology_HairSkin_Colors.h
//  BanubaDemo
//
//  Created by Pavel Bulochkin on 03.03.2018.
//

#ifndef BNBTechnology_HairSkin_Colors_h
#define BNBTechnology_HairSkin_Colors_h

#include "BNBTechnology_FRX.h"

#import "BNBRNDModelDataSkinAndHairColor.h"

class BNBTechnology_HairSkin_Colors : public BNBTechnology_FRX
{
public:
    BNBTechnology_HairSkin_Colors()
        : modelData([BNBRNDModelDataSkinAndHairColor new]),
          currentFeatures([NSMutableSet new]) {}

    bool RunModel(CVPixelBufferRef pixelBuffer);
    void setFeatures(NSSet<NSNumber*>* features);
    BNBRNDModelDataSkinAndHairColor* getModelData();
    
private:
    NSMutableSet<NSNumber*>* currentFeatures;
    BNBRNDModelDataSkinAndHairColor *modelData;
};

#endif /* BNBTechnology_HairSkin_Colors_h */
