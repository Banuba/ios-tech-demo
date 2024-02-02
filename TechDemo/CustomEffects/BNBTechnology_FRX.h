//
//  BNBTechnology_FRX.hpp
//  BanubaDemo
//
//  Created by Pavel Bulochkin on 28.02.2018.
//

#ifndef BNBTechnology_FRX_h
#define BNBTechnology_FRX_h

#include "BNBSdkCore/BNBFrameData.h"
#include "BNBSdkCore/BNBRecognizer.h"
#include "FRXDataStruct.h"
#include <opencv2/imgproc.hpp>

////////////////////////////////////////////////////////////////////////////////////////

class BNBTechnology_FRX
{
public:
    BNBTechnology_FRX();
    
    virtual ~BNBTechnology_FRX() {
        delete[] frxData.verticesArrayPtr;
    }
    
    void FRXProcessFrame(CVPixelBufferRef pixelBuffer);
    bool FRXDetectFaceMeshParameters(CVPixelBufferRef pixelBuffer);
    bool FRXDetectFaceMeshParametersHD(CVPixelBufferRef pixelBuffer);
    
    void FRXResetFaceMeshParameters();
    
    
    void FRXReprojectFaceMeshVertexesHD(const std::vector<int>& indexes,
                                        const float* model_view_m,
                                        const float* projection_m,
                                        const std::vector<float>& face_vertices,
                                        std::vector<std::pair<int, int>>& coords);
    
protected:
    BNBRecognizer *bnbrec;
    NSSet<NSNumber *> * featureSet;
    BNBFrameData* frameData;
    cv::Mat imageGray;
    cv::Mat imageLandmarks;
    FRXDataStruct frxData;
    
    const cv::Size2f kFRXResolution = { 480, 640 };
    const cv::Size2f kFRXResolutionHd = { 720, 1280 };
    
    const float kCoeffCamera = kFRXResolution.width / kFRXResolution.height ;
    const float kCoeffRatio = kFRXResolutionHd.height / kFRXResolution.height;
    const float kCoeffShift = kFRXResolution.width - kFRXResolutionHd.width / kCoeffRatio;
};

#endif /* BNBTechnology_FRX_h */
