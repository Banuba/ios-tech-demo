//
//  HairSkinColorsWrapper.h
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 15.03.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>

#import "BNBRNDModelDataSkinAndHairColor.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ColorFeature) {
    skinColor,
    hairColor
};

@interface HairSkinColorsWrapper : NSObject

- (void) setFeatureSet:(NSSet<NSNumber*>*)features;
- (BNBRNDModelDataSkinAndHairColor *)calculateColorsFromPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
