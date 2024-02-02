//
//  BNBTechnology_HairSkin_Colors.cpp
//  BanubaDemo
//
//  Created by Pavel Bulochkin on 03.03.2018.
//

#include "BNBTechnology_HairSkin_Colors.h"
#import <opencv2/imgcodecs/ios.h>
#import <BNBSdkCore/BNBFeatureId.h>
#include <iostream>
#include <algorithm>
#include <optional>
#include <array>
#include <vector>
#include <chrono>


#define HAIRLESS_POINTS_CRITERIA 35

struct IndexWrapper {
    int index;
    uint8_t val;
    
    inline bool operator<(IndexWrapper other) const noexcept {
        return val < other.val;
    }
};

union RGBPixel {
    uint8_t vals[3];
    struct {
        uint8_t r;
        uint8_t g;
        uint8_t b;
    };
};

// Uint8_t and Float variants differs in CV_type variable, template parameter for mat.at<> and function called on number
cv::Mat arrayToMatUint8(NSArray<NSNumber*>* nsNumberArray, cv::Size size) {
    cv::Mat mat(size, CV_8U);
    for (int i = 0; i < mat.rows; i++) {
        for (int j = 0; j < mat.cols; j++) {
            NSNumber* number = nsNumberArray[i * mat.cols + j];
            mat.at<unsigned char>(i, j) = [number unsignedCharValue];
        }
    }
    return mat;
}

cv::Mat arrayToMatFloat(NSArray<NSNumber*>* nsNumberArray, cv::Size size) {
    cv::Mat mat(size, CV_32F);
    for (int i = 0; i < mat.rows; i++) {
        for (int j = 0; j < mat.cols; j++) {
            NSNumber* number = nsNumberArray[i* mat.cols + j];
            mat.at<float>(i, j) = [number floatValue];
        }
    }
    return mat;
}

std::vector<uint8_t> arrayToVectorUint8(NSArray<NSNumber*>* nsNumberArray) {
    std::vector<uint8_t> resVector;
    resVector.reserve(nsNumberArray.count);
    for (NSNumber *number in nsNumberArray) {
        uint8_t value = [number unsignedCharValue];
        resVector.push_back(value);
    }
    return resVector;
}

std::vector<uint8_t> transformMask(BNBTransformedMaskByte* maskByte, cv::Mat imageTransform, cv::Size imageShape) {
    cv::Mat maskMat = arrayToMatUint8(maskByte.mask, {maskByte.meta.width, maskByte.meta.height});
    
    // Transform mask to image space
    cv::Mat basisTransform = arrayToMatFloat(maskByte.meta.basisTransform, {3, 3});
    cv::Mat affineTransform = (imageTransform * basisTransform.inv());
    
    std::vector<uint8_t> maskVec(imageShape.width * imageShape.height);
    cv::Mat dstMat(imageShape, CV_8U, maskVec.data());
    cv::warpAffine(maskMat, dstMat, affineTransform(cv::Rect(0,0,3,2)), dstMat.size(), cv::INTER_LINEAR);
    
    return maskVec;
}

using ImageVec = std::vector<RGBPixel>;
ImageVec filterImageWithMask(const ImageVec& imgVec, const std::vector<uint8_t>& maskVec) {
    assert(imgVec.size() == maskVec.size());
    std::vector<RGBPixel> filtered;
    
    // Choose pixels of the image which correspond to segmentation mask value > 128
    for (int i = 0; i < imgVec.size(); i++) {
        if (maskVec[i] > 128u) {
            filtered.push_back(imgVec[i]);
        }
    }
    
    return filtered;
}

cv::Vec3f calculateFace(const ImageVec& imgVec, BNBTransformedMaskByte* faceMask, cv::Mat imageTransform, cv::Size imageShape) {
    std::vector<uint8_t> faceMaskVec = transformMask(faceMask, imageTransform, imageShape);
    ImageVec maskedImage = filterImageWithMask(imgVec, faceMaskVec);

    if (maskedImage.size() <= 0) {
        throw [NSException exceptionWithName:@"FRXException" reason:@"Face mask is empty" userInfo:nil];
    }
    
    // Now we need HSV data of the image to get indices where V channel between 0.4 and 0.95 quantile.
    // These indices are used to filter original image data. V = max(R,G,B)
    std::vector<IndexWrapper> imgValueChannel;
    imgValueChannel.reserve(maskedImage.size());
    for (int i = 0; i < maskedImage.size(); i++) {
        imgValueChannel.push_back({ i, *std::max_element(maskedImage[i].vals, maskedImage[i].vals + 3) });
    }
    
    // Get 0.4 pertentile and 0.95
    auto valueQuantile40 = imgValueChannel.begin() + (imgValueChannel.size() * 0.4);
    std::nth_element(imgValueChannel.begin(), valueQuantile40, imgValueChannel.end());
    
    auto valueQunatile95 = imgValueChannel.begin() + (imgValueChannel.size() * 0.95);
    std::nth_element(valueQuantile40, valueQunatile95, imgValueChannel.end());
    
    cv::Vec3f meanRgb;
    for (auto it = valueQuantile40; it <= valueQunatile95; ++it) {
        meanRgb[0] += maskedImage[it->index].r;
        meanRgb[1] += maskedImage[it->index].g;
        meanRgb[2] += maskedImage[it->index].b;
    }
    size_t totalPixels = std::distance(valueQuantile40, valueQunatile95);
    meanRgb /= (float)totalPixels;
    
    return meanRgb;
}

cv::Vec3f calculateHair(const ImageVec& imgVec, BNBTransformedMaskByte* hairMask, cv::Mat imageTransform, cv::Size imageShape) {
    std::vector<uint8_t> hairMaskVec = transformMask(hairMask, imageTransform, imageShape);
    ImageVec maskedImage = filterImageWithMask(imgVec, hairMaskVec);

    if (maskedImage.size() <= 0) {
        throw [NSException exceptionWithName:@"FRXException"
               reason:@"Hair mask is empty"
               userInfo:nil];
    }
    
    // Now we need HSV data of the image to get indices where V channel is greater than 0.4 quuantile and S channel is greater than median.
    // These indices are used to filter original image data. V = max(R,G,B), S = 1 - min(R,G,B)/max(R,G,B)
    std::vector<IndexWrapper> imgValueChannel;
    imgValueChannel.reserve(maskedImage.size());
    std::vector<IndexWrapper> imgSaturationChannel;
    imgSaturationChannel.reserve(maskedImage.size());
    
    for (int i = 0; i < maskedImage.size(); i++) {
        auto [min, max] = std::minmax_element(maskedImage[i].vals, maskedImage[i].vals + 3);
        imgValueChannel.push_back({ i,  *max });
        uint8_t sat = *max != 0 ? (uint8_t)(255 * (1.0f - (float)*min / (float)*max)) : 0;
        imgSaturationChannel.push_back({ i, sat });
    }
    
    // Get 0.4 pertentile of Value
    auto valueQuantile40 = imgValueChannel.begin() + (imgValueChannel.size() * 0.4);
    std::nth_element(imgValueChannel.begin(), valueQuantile40, imgValueChannel.end());
    
    // Get 0.5 pertentile of Saturation
    auto medianSaturation = imgSaturationChannel.begin() + (imgSaturationChannel.size() * 0.5);
    std::nth_element(imgSaturationChannel.begin(), medianSaturation, imgSaturationChannel.end());
    
    cv::Vec3f meanRgb;
    int totalPixels = 0;
    for (auto it = medianSaturation; it < imgSaturationChannel.end(); ++it) {
        auto max = *std::max_element(maskedImage[it->index].vals, maskedImage[it->index].vals + 3);
        if ( max > valueQuantile40->val) {
            meanRgb[0] += maskedImage[it->index].r;
            meanRgb[1] += maskedImage[it->index].g;
            meanRgb[2] += maskedImage[it->index].b;
            ++totalPixels;
        }
    }
    if (totalPixels == 0) {
        throw [NSException exceptionWithName:@"FRXException" reason:@"Hair colour can't be computed" userInfo:nil];
    }
    meanRgb /= (float)totalPixels;
    
    return meanRgb;
}

void BNBTechnology_HairSkin_Colors::setFeatures(NSSet<NSNumber*>* newFeatures) {
    [modelData resetModel];
    
    currentFeatures = [NSMutableSet setWithSet: newFeatures];
    [bnbrec setFeatures: currentFeatures];
}


bool BNBTechnology_HairSkin_Colors::RunModel(CVPixelBufferRef pixelBuffer)
{
    CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    OSType format = CVPixelBufferGetPixelFormatType(pixelBuffer);
    if (format != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
        NSLog(@"Only YUV is supported");
        [modelData resetModel];
        CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
        return false;
    }
    
    FRXProcessFrame(pixelBuffer);
    
    ImageVec imgVec((int)CVPixelBufferGetHeight(pixelBuffer) * (int)CVPixelBufferGetWidth(pixelBuffer));
    
    cv::Mat imageRgb((int)CVPixelBufferGetHeight(pixelBuffer),
                     (int)CVPixelBufferGetWidth(pixelBuffer),
                     CV_8UC3, imgVec.data());
    cv::Mat yuvFrame((int)CVPixelBufferGetHeight(pixelBuffer) * 3/2, // yuv requires 12 bit per pixel
                    (int)CVPixelBufferGetWidth(pixelBuffer),
                    CV_8UC1, CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0));
    cv::cvtColor(yuvFrame, imageRgb, CV_YUV2RGB_NV12);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);

    
    cv::Mat imageTransform = arrayToMatFloat(frameData.getFullImgTransform, {3, 3});
    
    if ([currentFeatures containsObject: @(BNBFeatureIdFace)]) {
        @try {
            cv::Vec3f faceColor = calculateFace(imgVec, frameData.getFace, imageTransform, imageRgb.size());
            faceColor /= 255.0;
            UIColor *skinUIColor = [UIColor colorWithRed:faceColor[0] green:faceColor[1] blue:faceColor[2] alpha:1.0];
            modelData.skinColor = skinUIColor;
        }
        @catch (NSException *e) {
            return false;
        }
    }
    
    if ([currentFeatures containsObject: @(BNBFeatureIdHair)]) {
        @try {
            cv::Vec3f hairColor = calculateHair(imgVec, frameData.getHair, imageTransform, imageRgb.size());
            hairColor /= 255.0;
            UIColor *hairUIColor = [UIColor colorWithRed:hairColor[0] green:hairColor[1] blue:hairColor[2] alpha:1.0];
            modelData.hairColor = hairUIColor;
        }
        @catch (NSException *e) {
            return false;
        }
        
    }

    return true;
}

BNBRNDModelDataSkinAndHairColor* BNBTechnology_HairSkin_Colors::getModelData() {
    return modelData;
}
