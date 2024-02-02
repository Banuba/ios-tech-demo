//
//  EffectConfig.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 01.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import Foundation

enum CameraType {
    case front
    case back
}

enum Control {
    case slider(defaultValue: Float = 0.5)
    case `switch`(defaultValue: Bool = true)
}

enum PollingMethod {
    case gesturesDetection
    case distanceMeasurement
    case glassesDetection
}

enum Tooltip: String {
    enum DismissCondition {
        case timer(seconds: TimeInterval)
        case pollingMethod(name: String)
    }
    
    case nailsColoring
    case handGesture
    case multipleFaces
    case background360
    case gangster
    case octopus
    case acneRemoval
    case takePhoto
    
    var dismissCondition: DismissCondition? {
        switch self {
        case .nailsColoring:
            return .timer(seconds: 3)
        case .multipleFaces:
            return .timer(seconds: 5)
        case .gangster, .octopus:
            return .pollingMethod(name: "GetMouthStatus()")
        case .background360:
            return .pollingMethod(name: "onDataUpdate()")
        case .handGesture:
            return nil
        case .acneRemoval:
            return .pollingMethod(name: "GetTouchStatus()")
        case .takePhoto:
            return .timer(seconds: 5)
        }
    }
}

enum EffectPreview: Hashable {
    case uniqueIcon(named: String)
    case color(hex: Int)
    case templatedIcon(named: String, letter: Character)
    case none
}

enum EffectType: Equatable {
    case standard(name: String)
    case skinColor
    case hairColor
    case acneRemoval
}

enum MediaType: Equatable {
    case video
    case photo
}

enum EffectViewScaling: Equatable {
    case AspectFill // change effectView's size to fill available screen space, crops top of the rendering area. Preserves effectPlayer's renderingSize aspectRatio,
    case FitScreen  // changes effectView's size and rendering size to fit available screen space
}

struct EffectConfig: Equatable {
    let effect: EffectType
    let preview: EffectPreview
    let mediaType : MediaType
    let jsConfig: String?
    let preferredCamera: CameraType
    let tooltip: Tooltip?
    let control: Control?
    let pollingMethod: PollingMethod?
    let screenScaling: EffectViewScaling
    
    static func == (lhs: EffectConfig, rhs: EffectConfig) -> Bool {
        lhs.effect == rhs.effect && lhs.jsConfig == rhs.jsConfig
    }
    
    init(effectName: String, preview: EffectPreview, media: MediaType = .video, jsConfig: String? = nil,
         preferredCamera: CameraType = .front, tooltip: Tooltip? = nil,
         control: Control? = nil, pollingMethod: PollingMethod? = nil,
         screenScaling: EffectViewScaling = .AspectFill
    ) {
        self.effect = .standard(name: effectName)
        self.preview = preview
        self.mediaType = media
        self.jsConfig = jsConfig
        self.preferredCamera = preferredCamera
        self.tooltip = tooltip
        self.control = control
        self.pollingMethod = pollingMethod
        self.screenScaling = screenScaling
    }
    
    
    init(effect: EffectType, preview: EffectPreview = .none, media: MediaType = .video, jsConfig: String? = nil,
         preferredCamera: CameraType = .front, tooltip: Tooltip? = nil,
         control: Control? = nil, pollingMethod: PollingMethod? = nil,
         screenScaling: EffectViewScaling = .AspectFill
    ) {
        self.effect = effect
        self.preview = preview
        self.mediaType = media
        self.jsConfig = jsConfig
        self.preferredCamera = preferredCamera
        self.tooltip = tooltip
        self.control = control
        self.pollingMethod = pollingMethod
        self.screenScaling = screenScaling
    }
}
