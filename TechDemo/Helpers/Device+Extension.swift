//
//  Device+Extension.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 06.04.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import Device

extension Device {
    // https://github.com/hollance/neural-engine/blob/master/docs/supported-devices.md
    static func hasNE() -> Bool {
        switch version() {
        case .unknown, .simulator, .iPhone6S, .iPhone6SPlus, .iPhoneSE, .iPhone7, .iPhone7Plus,
                .iPhone8, .iPhone8Plus, .iPhoneX, .iPad5, .iPad6, .iPad7, .iPadPro9_7Inch,
                .iPadPro10_5Inch, .iPadPro12_9Inch, .iPadPro12_9Inch2,  .iPodTouch7Gen,
                .iPadAir2, .iPadMini4:
            return false
        default:
            return true
        }
    }
}
