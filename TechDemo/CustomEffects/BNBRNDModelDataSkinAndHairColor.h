//
//  BNBRNDModelDataSkinAndHairColor.h
//  TechDemo
//
//  Created by Alexey Ereschenko on 8/29/18.
//  Copyright © 2018 Banuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNBRNDModelDataSkinAndHairColor : NSObject

@property (strong, nonatomic, nullable) UIColor *skinColor;
@property (strong, nonatomic, nullable) UIColor *hairColor;
@property (assign, nonatomic) BOOL isHairless;

- (void) resetModel;

@end
