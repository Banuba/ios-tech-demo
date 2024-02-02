//
//  DeviceCapabilitiesService.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 07.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import Device
import AVFoundation

final class DeviceCapabilitiesService {
    var renderSize: CGSize {
        isOldDevice ? CGSize(width: 720, height: 1280) : CGSize(width: 1080, height: 1920)
    }
    
    var captureSessionPreset: AVCaptureSession.Preset {
        isOldDevice ? .hd1280x720 : .hd1920x1080
    }
    
    private var isOldDevice: Bool {
        // Check perf witn 720p on all devices
        return true
//        switch Device.version() {
//        case .iPhone6S, .iPhone6SPlus, .iPhoneSE, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus:
//            return true
//        default:
//            return false
//        }
    }
}
