//
//  BNBTechnology_FRX.cpp
//  BanubaDemo
//
//  Created by Pavel Bulochkin on 28.02.2018.
//

#include <iostream>

#include "BNBTechnology_Execute.h"
#include "BNBTechnology_FRX.h"

//#define FRX_DRAW_LANDMARKS

////////////////////////////////////////////////////////////////////////////////////////

BNBTechnology_FRX::BNBTechnology_FRX()
{
    bnbrec = [BNBRecognizer create:BNBRecognizerModeSynchronous];
    featureSet = [NSSet<NSNumber *> setWithObjects:@(BNBFeatureIdFrx), @(BNBFeatureIdActionUnits), nil];
    [bnbrec setFeatures:featureSet];
}

void BNBTechnology_FRX::FRXReprojectFaceMeshVertexesHD(const std::vector<int>& indexes,
                                                       const float* model_view_m,
                                                       const float* projection_m,
                                                       const std::vector<float>& face_vertices,
                                                       std::vector<std::pair<int, int>>& coords)
{
    cv::Mat mtx_model_view(1, 16, CV_32FC1, (void*)model_view_m);
    cv::Mat mtx_projection(1, 16, CV_32FC1, (void*)projection_m);
    
    mtx_model_view = mtx_model_view.reshape(1, 4);
    mtx_projection = mtx_projection.reshape(1, 4);

    const int vsize = (face_vertices.size() > VERTEX_NUMBER * 3) ? VERTEX_NUMBER * 3 : (int)face_vertices.size();
    
    float* ptr_vertices =  (float*) malloc (vsize * sizeof(float));
    
    auto x_index = 0 * vsize / 3 ;
    auto y_index = 1 * vsize / 3 ;
    auto z_index = 2 * vsize / 3 ;
    
    for (auto i = 0 ; i < vsize ; i += 3)
    {
        ptr_vertices[x_index++] = face_vertices[i + 0];
        ptr_vertices[y_index++] = face_vertices[i + 1];
        ptr_vertices[z_index++] = face_vertices[i + 2];
    }

    cv::Mat mtx_vertices(1, vsize, CV_32FC1, ptr_vertices);
    static cv::Mat mtx_onces(1, vsize / 3, CV_32FC1, cv::Scalar(1.0));
    
    mtx_vertices = mtx_vertices.reshape(1, 3);

    cv::vconcat(mtx_vertices, mtx_onces, mtx_vertices);
    cv::Mat mtx_reproject = mtx_model_view * mtx_projection;
    
    cv::transpose(mtx_reproject, mtx_reproject);
    cv::Mat mtx_final = mtx_reproject * mtx_vertices;
    
    cv::Mat plane_X = mtx_final.row(0) / mtx_final.row(3);
    cv::Mat plane_Y = mtx_final.row(1) / mtx_final.row(3);
    
    plane_X = plane_X * 240.0f + 240.0f;
    plane_Y = 320.0f - plane_Y * 320.0f;
    
    std::vector<float> Cb, Cr;
    for (auto i = 0 ; i < indexes.size() ; i++)
    {
        float X_coord = plane_X.at<float>(0, indexes[i]) * 2 - 120 ;
        float Y_coord = plane_Y.at<float>(0, indexes[i]) * 2 ;
        
        if (X_coord >= 0 && Y_coord >= 0 && X_coord <= 719  && Y_coord <= 1279)
        {
            coords.emplace_back(kFRXResolutionHd.width - X_coord, Y_coord);
        }
    }
}

void BNBTechnology_FRX::FRXProcessFrame(CVPixelBufferRef pixelBuffer) {
    frameData = [BNBFrameData create];
    const auto fov = BNBTechnologyExecute::GetModelsVideoFieldOfView();
    auto image = [[BNBFullImageData alloc] init:pixelBuffer cameraOrientation:BNBCameraOrientationDeg90 requireMirroring:false faceOrientation:0 fieldOfView:fov];
    
    [frameData addFullImg:image];
    [bnbrec setOfflineMode:false];
    [bnbrec process:frameData];
}

bool BNBTechnology_FRX::FRXDetectFaceMeshParameters(CVPixelBufferRef pixelBuffer)
{
    FRXProcessFrame(pixelBuffer);
    
    BNBFrxRecognitionResult* frxResult = frameData.getFrxRecognitionResult;
    
    auto faces = [frxResult getFaces];
    auto cameraPosition = [[faces objectAtIndex:0] getCameraPosition];
    auto landmarks = [[[frxResult getFaces] objectAtIndex:0] getLandmarks];
    
    frxData.twoDLandmarkCount = (int)landmarks.count / 2;
    for (int i = 0 ; i < frxData.twoDLandmarkCount * 2 ; i += 2)
    {
        frxData.twoDLandmarks[i] = [landmarks[i] doubleValue];
        frxData.twoDLandmarks[i + 1] = [landmarks[i + 1] doubleValue];
        
        frxData.twoDLandmarksLegacy[i] =  kFRXResolution.width - frxData.twoDLandmarks[i + 1];
        frxData.twoDLandmarksLegacy[i + 1] = frxData.twoDLandmarks[i];
    }
    
    auto faceRect = [faces[0] getFaceRect];
    frxData.faceRectangle.hasFaceRectangle = faces[0].hasFace;
    frxData.faceRectangle.leftBottom_x = faceRect.x;
    frxData.faceRectangle.leftBottom_y = faceRect.y + faceRect.h;
    frxData.faceRectangle.leftTop_x = faceRect.x;
    frxData.faceRectangle.leftTop_y = faceRect.y;
    frxData.faceRectangle.rightBottom_x = faceRect.x + faceRect.w;
    frxData.faceRectangle.rightBottom_y = faceRect.y + faceRect.h;
    frxData.faceRectangle.rightTop_x = faceRect.x + faceRect.w;
    frxData.faceRectangle.rightTop_y = faceRect.y;
    
    frxData.faceRectangleLegacy = frxData.faceRectangle;
    
    auto vertices = [faces[0] getVertices];
    frxData.verticesArraySize = (int)[vertices count];
    
    delete[] frxData.verticesArrayPtr;
    frxData.verticesArrayPtr = new float[frxData.verticesArraySize];
    
    for(int i = 0; i < frxData.verticesArraySize; ++i)
    {
        frxData.verticesArrayPtr[i] = [vertices[i] floatValue];
    }

    for(int i = 0; i < 16; ++i)
    {
        frxData.detectedCameraPosition.model_view_m[i] = [cameraPosition.modelViewM[i] floatValue];
        frxData.detectedCameraPosition.projection_m[i] = [cameraPosition.projectionM[i] floatValue];
    }

    if (!frxData.faceRectangle.hasFaceRectangle || frxData.twoDLandmarkCount != FRX2_MAX_LANDMARK_COUNT)
    {
        return false;
    }
    
    if (frxData.faceRectangle.leftBottom_x == 0 && frxData.faceRectangle.leftBottom_y == 0 &&
        frxData.faceRectangle.leftTop_x == 0 && frxData.faceRectangle.leftTop_y == 0 &&
        frxData.faceRectangle.rightTop_x == 0 && frxData.faceRectangle.rightTop_y == 0 &&
        frxData.faceRectangle.rightBottom_x == 0 && frxData.faceRectangle.rightBottom_y == 0)
    {
        return false;
    }
    
    #ifdef FRX_DRAW_LANDMARKS
        cv::Mat imageLandmarks((int)CVPixelBufferGetHeight(pixelBuffer),
                               (int)CVPixelBufferGetWidth(pixelBuffer),
                               CV_8UC4, CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0));

        cv::cvtColor(imageLandmarks, imageLandmarks, cv::COLOR_BGRA2RGB);
        cv::Mat imageLegacy = imageLandmarks.clone();
    
        for (int i = 0 ; i <  frxData.twoDLandmarkCount * 2; i += 2)
        {
            cv::Point2f lnd(frxData.twoDLandmarks[i], frxData.twoDLandmarks[i + 1]);
            cv::circle(imageLandmarks, lnd, 2.0f, cv::Scalar(255, 0, 0), cv::FILLED);
        }
    
        cv::Point leftUP(frxData.faceRectangle.leftTop_x, frxData.faceRectangle.leftTop_y);
        cv::Point rightDown(frxData.faceRectangle.rightBottom_x, frxData.faceRectangle.rightBottom_y);
        cv::rectangle(imageLandmarks, leftUP, rightDown, cv::Scalar(255 , 0 , 0));

        cv::transpose(imageLegacy, imageLegacy);
    
        for (int i = 0 ; i <  frxData.twoDLandmarkCount * 2 ; i += 2)
        {
            cv::Point2f lnd(kFRXResolution.width - frxData.twoDLandmarksLegacy[i], frxData.twoDLandmarksLegacy[i + 1]);
            cv::circle(imageLegacy, lnd, 2.0f, cv::Scalar(255, 0, 0), cv::FILLED);
        }

        auto img = MatToUIImage(imageLandmarks);
        auto imgLegacy = MatToUIImage(imageLegacy);
    
    #endif
    
    return true;
}

bool BNBTechnology_FRX::FRXDetectFaceMeshParametersHD(CVPixelBufferRef pixelBuffer)
{
    if (!FRXDetectFaceMeshParameters(pixelBuffer))
    {
        return false;
    }
    
    frxData.detectedCameraPosition.projection_m[0] /= kCoeffCamera;
    
    for (int i = 0 ; i < frxData.twoDLandmarkCount * 2 ; i += 2)
    {
        frxData.twoDLandmarksLegacy[i] = kFRXResolutionHd.width - frxData.twoDLandmarks[i + 1];
        frxData.twoDLandmarksLegacy[i + 1] = frxData.twoDLandmarks[i];
    }
    
    frxData.faceRectangleLegacy = frxData.faceRectangle;
    
    std::swap(frxData.faceRectangleLegacy.leftBottom_x, frxData.faceRectangleLegacy.leftBottom_y);
    std::swap(frxData.faceRectangleLegacy.leftTop_x, frxData.faceRectangleLegacy.leftTop_y);
    std::swap(frxData.faceRectangleLegacy.rightTop_x, frxData.faceRectangleLegacy.rightTop_y);
    std::swap(frxData.faceRectangleLegacy.rightBottom_x, frxData.faceRectangleLegacy.rightBottom_y);
    
#ifdef FRX_DRAW_LANDMARKS
    
    cv::Mat imageLandmarks((int)CVPixelBufferGetHeight(pixelBuffer),
                           (int)CVPixelBufferGetWidth(pixelBuffer),
                           CV_8UC4, CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0));
    
    cv::cvtColor(imageLandmarks, imageLandmarks, cv::COLOR_BGRA2RGB);
    cv::Mat imageLegacy = imageLandmarks.clone();
    
    for (int i = 0 ; i <  frxData.twoDLandmarkCount * 2 ; i += 2)
    {
        cv::Point2f lnd(frxData.twoDLandmarks[i], frxData.twoDLandmarks[i + 1]);
        cv::circle(imageLandmarks, lnd, 2.0f, cv::Scalar(0, 255, 0), cv::FILLED);
    }
    
    cv::Point leftUP(frxData.faceRectangle.leftTop_x, frxData.faceRectangle.leftTop_y);
    cv::Point rightDown(frxData.faceRectangle.rightBottom_x, frxData.faceRectangle.rightBottom_y);
    cv::rectangle(imageLandmarks, leftUP, rightDown, cv::Scalar(0 , 255 , 0));
    
    cv::Point leftUPLegacy(frxData.faceRectangleLegacy.leftTop_x, frxData.faceRectangleLegacy.leftTop_y);
    cv::Point rightDownLegacy(frxData.faceRectangleLegacy.rightBottom_x, frxData.faceRectangleLegacy.rightBottom_y);
    
    cv::transpose(imageLegacy, imageLegacy);
    cv::rectangle(imageLegacy, leftUPLegacy, rightDownLegacy, cv::Scalar(0 , 0 , 255)); //  kFRXResolutionHd.width -
    
    for (int i = 0 ; i <  frxData.twoDLandmarkCount * 2 ; i += 2)
    {
        cv::Point2f lnd(kFRXResolutionHd.width - frxData.twoDLandmarksLegacy[i], frxData.twoDLandmarksLegacy[i + 1]);
        cv::circle(imageLegacy, lnd, 2.0f, cv::Scalar(255, 0, 0), cv::FILLED);
    }
    
    auto img = MatToUIImage(imageLandmarks);
    auto imgLegacy = MatToUIImage(imageLegacy);
    
#endif

    return true;
}

void BNBTechnology_FRX::FRXResetFaceMeshParameters()
{
    delete[] frxData.verticesArrayPtr;
    memset(&frxData, 0, sizeof(frxData));
}
