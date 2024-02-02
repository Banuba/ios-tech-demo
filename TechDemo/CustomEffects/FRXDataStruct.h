//
//  FRXDataStruct.h
//  Banuba
//
//  Created by Alexey Ereschenko on 24/01/2017.
//  Copyright © 2017 Banuba. All rights reserved.
//

#ifndef FRXDataStruct_h
#define FRXDataStruct_h

#include "BNBSdkCore/BNBFrxRecognitionResult.h"
#include "BNBSdkCore/BNBFaceData.h"

#define FRX2_ACTION_UNITS_COUNT 51
#define FRX2_MAX_LANDMARK_COUNT 68
#define VERTEX_NUMBER        3308

typedef struct frx_face_rectangle
{
    int hasFaceRectangle;
    float leftTop_x;
    float leftTop_y;
    float rightTop_x;
    float rightTop_y;
    float rightBottom_x;
    float rightBottom_y;
    float leftBottom_x;
    float leftBottom_y;
} FRX_FACE_RECTANGLE;

typedef struct frx_camera_position {
    float model_view_m[16];
    float projection_m[16];
    float face_box[16];
} FRX_CAMERA_POSITION;

typedef struct FRXData {
    int twoDLandmarkCount;
    
    float twoDLandmarks[FRX2_MAX_LANDMARK_COUNT * 2];
    FRX_FACE_RECTANGLE faceRectangle;
    
    float twoDLandmarksLegacy[FRX2_MAX_LANDMARK_COUNT * 2];
    FRX_FACE_RECTANGLE faceRectangleLegacy;
    
    int verticesArraySize;
    float *verticesArrayPtr = nullptr;
    
    FRX_CAMERA_POSITION detectedCameraPosition;
} FRXDataStruct;

#endif /* FRXDataStruct_h */
