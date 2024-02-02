//
//  Technology.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 02.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//


import Device
 
private let hasNE: Bool = {
    Device.hasNE()
}()

enum Technology: Int, CaseIterable {
    case virtualTryOn
    case beauty
    case arVideoCall
    case handTracking
    case faceMasks
    case faceTracking
    case arGames
    case avatar
    
    var title: String {
        switch self {
        case .virtualTryOn: return "Virtual Try On"
        case .beauty: return "Touch Up"
        case .arVideoCall: return "AR VideoCall"
        case .handTracking: return "Hand Tracking"
        case .faceMasks: return "Face Masks"
        case .faceTracking: return "Face Tracking"
        case .arGames: return "AR Games"
        case .avatar: return "Avatar"
        }
    }
    
    var deepLinkId: String {
        switch self {
        case .virtualTryOn: return "virtual_try_on"
        case .beauty: return "beauty_touch_up"
        case .arVideoCall: return "ar_videocall"
        case .handTracking: return "hand_tracking"
        case .faceMasks: return "face_masks"
        case .faceTracking: return "face_tracking"
        case .arGames: return "ar_games"
        case .avatar: return "avatar"
        }
    }
    
    var categories: [EffectsCategory] {
        switch self {
        case .virtualTryOn:
            return [
                EffectsCategory(
                    title: "Glasses Try On",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Frames",
                            effectsList: [
                                .init(effectName: "Glasses_Clear", preview: .uniqueIcon(named: "glasses_clear")),
                                .init(effectName: "glasses_RayBan4165_Dark", preview: .uniqueIcon(named: "glasses_dark")),
                            ]
                        ),
                        EffectsGroup(
                            title: "Contact Lenses",
                            effectsList: [
                                .init(effectName: "Eye_lenses_Blue", preview: .color(hex: 0x33B3FF)),
                                .init(effectName: "Eye_lenses_Green", preview: .color(hex: 0x33FF33)),
                            ]
                        ),
                    ],
                    deepLinkId: "glasses"
                ),
                EffectsCategory(
                    title: "Head wearings",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Headdress",
                            effectsList: [
                                .init(effectName: "VTO_Headdresse_01_9b6e65f", preview: .templatedIcon(named: "head_wearings", letter: "A")),
                                .init(effectName: "VTO_Headdresse_cap_8f41bee", preview: .templatedIcon(named: "head_wearings", letter: "B")),
                            ]
                        ),
                        EffectsGroup(
                            title: "Jewelry",
                            effectsList: [
                                .init(effectName: "VTO_tiara_acf75a6", preview: .none),
                            ]
                        ),
                    ],
                    deepLinkId: "head_wearings"
                ),
                EffectsCategory(
                    title: "Jewelry",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Earrings",
                            effectsList: [
                                .init(effectName: "earrings_01", preview: .templatedIcon(named: "earrings", letter: "A")),
                                .init(effectName: "earrings_02", preview: .templatedIcon(named: "earrings", letter: "B")),
                            ]
                        ),
                        EffectsGroup(
                            title: "Necklace",
                            effectsList: [
                                .init(effectName: "necklace_01", preview: .templatedIcon(named: "necklace", letter: "A")),
                                .init(effectName: "necklace_02", preview: .templatedIcon(named: "necklace", letter: "B")),
                            ]
                        ),
                    ],
                    deepLinkId: "jewelry"
                ),
                EffectsCategory(
                    title: "Makeup",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Face",
                            effectsList: [
                                .init(effectName: hasNE ? "VTO_Makeup" : "Low_Foundation_C110_8c94a38",
                                      preview: .templatedIcon(named: "foundation", letter: "A"),
                                      jsConfig: hasNE ? JSConfig.foundationC110 : nil),
                                .init(effectName: hasNE ? "VTO_Makeup" : "Low_Foundation_C190_8c94a38",
                                      preview: .templatedIcon(named: "foundation", letter: "B"),
                                      jsConfig: hasNE ? JSConfig.foundationC190 : nil),
                            ]
                        ),
                        EffectsGroup(
                            title: "Lips",
                            effectsList: [
                                .init(effectName: hasNE ? "VTO_Makeup" : "Low_Lipstick_GUCCI_8c94a38",
                                      preview: .templatedIcon(named: "lips", letter: "A"),
                                      jsConfig: hasNE ? JSConfig.lipstickGucci : nil),
                                .init(effectName: hasNE ? "VTO_Makeup" : "Low_Lipstick_REVLON_8c94a38",
                                      preview: .templatedIcon(named: "lips", letter: "B"),
                                      jsConfig: hasNE ? JSConfig.lipstickRevlon : nil),
                            ]
                        ),
                        EffectsGroup(
                            title: "Eyes",
                            effectsList: [
                                .init(effectName: hasNE ? "VTO_Makeup" : "Low_Eyeshadow_1_7dc90d8",
                                      preview: .templatedIcon(named: "eyes", letter: "A"),
                                      jsConfig: hasNE ? JSConfig.eyeshadowCOSNOVA : nil),
                                .init(effectName: hasNE ? "VTO_Makeup" : "Low_Eyeshadow_2_7dc90d8",
                                      preview: .templatedIcon(named: "eyes", letter: "B"),
                                      jsConfig: hasNE ? JSConfig.eyeshadowGUCCI : nil),
                            ]
                        ),
                        EffectsGroup(
                            title: "Looks",
                            effectsList: [
                                .init(effectName: hasNE ? "VTO_Makeup" : "Low_look_clubs_8c94a38",
                                      preview: .templatedIcon(named: "looks", letter: "A"),
                                      jsConfig: hasNE ? JSConfig.lookGucci : nil),
                                .init(effectName: hasNE ? "VTO_Makeup" : "Low_look_relook_8c94a38",
                                      preview: .templatedIcon(named: "looks", letter: "B"),
                                      jsConfig: hasNE ? JSConfig.lookRevlon : nil),
                            ]
                        ),
                    ],
                    deepLinkId: "makeup"
                ),
                EffectsCategory(
                    title: "Nails coloring",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Color",
                            effectsList: [
                                .init(effectName: "nails_pink", preview: .color(hex: 0xC74D8F), preferredCamera: .back, tooltip: .nailsColoring),
                                .init(effectName: "nails_cyan", preview: .color(hex: 0x8FC7A1), preferredCamera: .back, tooltip: .nailsColoring),
                            ]
                        ),
                        EffectsGroup(
                            title: "Image",
                            effectsList: [
                                .init(effectName: "VTO_Nails_patternBlack", preview: .uniqueIcon(named: "nails_pattern_1"), preferredCamera: .back, tooltip: .nailsColoring),
                                .init(effectName: "VTO_Nails_patternColor", preview: .uniqueIcon(named: "nails_pattern_2"), preferredCamera: .back, tooltip: .nailsColoring),
                            ]
                        ),
                    ],
                    deepLinkId: "nails"
                ),
                EffectsCategory(
                    title: "Hair Coloring",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "VTO_Hair_green", preview: .color(hex: 0x45AB70)),
                                .init(effectName: "VTO_Hair_blue", preview: .color(hex: 0x154F9F)),
                                .init(effectName: "VTO_Hair_strand", preview: .color(hex: 0xC98DBD)),
                            ]
                        ),
                    ],
                    deepLinkId: "hair"
                ),
            ]
        case .beauty:
            return [
                EffectsCategory(
                    title: "Skin",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Skin sharpness",
                            effectsList: [
                                .init(effectName: "SkinSmoothing_1.8.0", preview: .none, control: .slider()),
                            ]
                        ),
                        EffectsGroup(
                            title: "Acne",
                            effectsList: [
                                .init(effect: .acneRemoval, preview: .none, media: .photo, preferredCamera: .front, tooltip: .acneRemoval, control: .slider(defaultValue: 0.0)),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Face morphing",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Face",
                            effectsList: [
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "face_narrowing"),
                                    jsConfig: "face_template = {narrowing: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "face_v_shape"),
                                      jsConfig: "face_template = {v_shape: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "cheekbones_narrowing"),
                                      jsConfig: "face_template = {cheekbones_narrowing: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "cheeks_narrowing"),
                                      jsConfig: "face_template = {cheeks_narrowing: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "jaw_narrowing"),
                                      jsConfig: "face_template = {jaw_narrowing: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "chin_shortening"),
                                      jsConfig: "face_template = {chin_shortening: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "chin_narrowing"),
                                      jsConfig: "face_template = {chin_narrowing: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "sunken_cheeks"),
                                      jsConfig: "face_template = {sunken_cheeks: (slider) => slider}", control: .slider(defaultValue: 0.0)),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "cheeks_jaw_narrowing"),
                                      jsConfig: "face_template = {cheeks_jaw_narrowing: (slider) => slider * 2 - 1.0}", control: .slider()),
                            ]
                        ),
                        EffectsGroup(
                            title: "Nose",
                            effectsList: [
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "nose_width"),
                                    jsConfig: "nose_template = {width: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "nose_length"),
                                    jsConfig: "nose_template = {length: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "nose_tip_width"),
                                    jsConfig: "nose_template = {tip_width: (slider) => -slider * 2 + 1.0}", control: .slider()),
                            ]
                        ),
                        EffectsGroup(
                            title: "Mouth",
                            effectsList: [
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "lips_size"),
                                    jsConfig: "lips_template = {size: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "lips_height"),
                                    jsConfig: "lips_template = {height: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "lips_thickness"),
                                    jsConfig: "lips_template = {thickness: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "mouth_size"),
                                    jsConfig: "lips_template = {mouth_size: (slider) => -slider * 2 + 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "lips_smile"),
                                    jsConfig: "lips_template = {smile: (slider) => slider}", control: .slider(defaultValue: 0)),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "lips_shape"),
                                    jsConfig: "lips_template = {shape: (slider) => -slider * 2 + 1.0}", control: .slider()),
                            ]
                        ),
                        EffectsGroup(
                            title: "Eyes",
                            effectsList: [
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "eyes_rounding"),
                                    jsConfig: "eyes_template = {rounding: (slider) => slider}", control: .slider(defaultValue: 0)),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "eyes_enlargement"),
                                    jsConfig: "eyes_template = {enlargement: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "eyes_height"),
                                    jsConfig: "eyes_template = {height: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "eyes_spacing"),
                                    jsConfig: "eyes_template = {spacing: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "eyes_squint"),
                                    jsConfig: "eyes_template = {squint: (slider) => -slider * 2 + 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "lower_eyelid_pos"),
                                    jsConfig: "eyes_template = {lower_eyelid_pos: (slider) => slider * 2 - 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "upper_eyelid_pos"),
                                      jsConfig: "eyes_template = {lower_eyelid_size: (slider) => -slider * 2 + 1.0}", control: .slider()), // morphing param currently has name lower_eyelid_size
                            ]
                        ),
                        EffectsGroup(
                            title: "Eyebrows",
                            effectsList: [
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "eyebrows_spacing"),
                                    jsConfig: "eyebrows_template = {spacing: (slider) => -slider * 2 + 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "eyebrows_height"),
                                    jsConfig: "eyebrows_template = {height: (slider) => -slider * 2 + 1.0}", control: .slider()),
                                .init(effectName: "Morphings_1.7.0", preview: .uniqueIcon(named: "eyebrows_bend"),
                                    jsConfig: "eyebrows_template = {bend: (slider) => slider * 2 - 1.0}", control: .slider()),
                                
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Whitening",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Eye Whitening",
                            effectsList: [
                                .init(effectName: "EyesWitening_Toggle_064fc2c", preview: .none, control: .switch()),
                            ]
                        ),
                        EffectsGroup(
                            title: "Tooth Whitening",
                            effectsList: [
                                .init(effectName: "TeethWitening_Toggle_f6550e5", preview: .none, control: .switch()),
                            ]
                        ),
                    ]
                )
            ]
        case .arVideoCall:
            return [
                EffectsCategory(
                    title: "Background separation",
                    effectsGroups: [
                        EffectsGroup(
                            title: "360 backgrounds",
                            effectsList: [
                                .init(effectName: "360_CubemapEverest_noSound_7c98db1", preview: .templatedIcon(named: "360_backgrounds", letter: "A"), tooltip: .background360),
//                                .init(effectName: "", preview: .templatedIcon(named: "360_backgrounds", letter: "B")),
                            ]
                        ),
                        EffectsGroup(
                            title: "AR Background",
                            effectsList: [
                                .init(effectName: "Regular_Dawn_of_nature_6716e33", preview: .templatedIcon(named: "regular_background", letter: "A")),
                                .init(effectName: "Regular_blur_512984e", preview: .templatedIcon(named: "regular_background", letter: "B")),
                            ]
                        ),
                        EffectsGroup(
                            title: "Animated Background",
                            effectsList: [
                                .init(effectName: "video_BG_Metro_sfx_de62811", preview: .templatedIcon(named: "video_texture_background", letter: "A")),
                                .init(effectName: "video_BG_RainyCafe_6716e33", preview: .templatedIcon(named: "video_texture_background", letter: "B")),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Lightning and Color",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Sunset_6ff084f", preview: .templatedIcon(named: "color_correction", letter: "A")),
                                .init(effectName: "prequel_VE_543daa6", preview: .templatedIcon(named: "color_correction", letter: "B")),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Touch Up Filters",
                    effectsGroups: [
                        EffectsGroup(
                            title: "No makeup",
                            effectsList: [
                                .init(effectName: "dialect_9f86b27", preview: .templatedIcon(named: "looks", letter: "A")),
                                .init(effectName: "WhooshBeautyFemale_9f86b27", preview: .templatedIcon(named: "looks", letter: "B")),
                            ]
                        ),
                        EffectsGroup(
                            title: "Makeup",
                            effectsList: [
                                .init(effectName: "clubs_9f86b27", preview: .templatedIcon(named: "lipstick_powder_box", letter: "A")),
                                .init(effectName: "relook_9f86b27", preview: .templatedIcon(named: "lipstick_powder_box", letter: "B")),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "AR Face Masks",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Face morphing",
                            effectsList: [
                                .init(effectName: "Nerd2_59e9dbd", preview: .uniqueIcon(named: "nerd_2")),
                                .init(effectName: "TrollGrandma_f87f5c3", preview: .uniqueIcon(named: "troll_grandma"), jsConfig: JSConfig.trollGrandmaNoSound),
                            ]
                        ),
                        EffectsGroup(
                            title: "Skin animation",
                            effectsList: [
                                .init(effectName: "Graduate_d30bea8", preview: .uniqueIcon(named: "graduate")),
                                .init(effectName: "CartoonOctopus_f87f5c3", preview: .uniqueIcon(named: "cartoon_octopus"), jsConfig: JSConfig.octopusNoSound),
                            ]
                        ),
                        EffectsGroup(
                            title: "Foreground effects",
                            effectsList: [
                                .init(effectName: "frame1_59e9dbd", preview: .uniqueIcon(named: "frame_1")),
                                .init(effectName: "RainbowBeauty_59e9dbd", preview: .uniqueIcon(named: "rainbow_beauty")),
                            ]
                        ),
                    ]
                )
            ]
        case .handTracking:
            return [
                EffectsCategory(
                    title: "Gestures Detection",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Detection_gestures_fe35b8f", preview: .none, tooltip: .handGesture, pollingMethod: .gesturesDetection),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Rings try on",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Ring_01_1619395", preview: .templatedIcon(named: "ring", letter: "A"), preferredCamera: .back),
                                .init(effectName: "Ring_02_1619395", preview: .templatedIcon(named: "ring", letter: "B"), preferredCamera: .back),
                            ]
                        ),
                    ],
                    deepLinkId: "rings"
                )
            ]
        case .faceMasks:
            return [
                EffectsCategory(
                    title: "Animation",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "InFlames_81e2e18", preview: .uniqueIcon(named: "in_flames")),
                                .init(effectName: "Spider2_d55387a", preview: .uniqueIcon(named: "spider")),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Masks with Morphing",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "TrollGrandma_f87f5c3", preview: .uniqueIcon(named: "troll_grandma"), jsConfig: JSConfig.trollGrandmaWithSound),
                                .init(effectName: "Bullfighter_db6ada9", preview: .uniqueIcon(named: "bullfighter")),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Triggers",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "CartoonOctopus_f87f5c3", preview: .uniqueIcon(named: "cartoon_octopus"), jsConfig: JSConfig.octopusWithSound, tooltip: .octopus),
                                .init(effectName: "Gangster_59b8ef7", preview: .uniqueIcon(named: "gangster"), tooltip: .gangster),
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Multiple Face Detection",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "MinnieMouse7_multi_e2edce5", preview: .uniqueIcon(named: "minnie_mouse_7"), tooltip: .multipleFaces),
                                .init(effectName: "UnluckyWitch_multi_a33d4a9", preview: .uniqueIcon(named: "unlucky_witch"), tooltip: .multipleFaces),
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Physics",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "MonsterFlowery_9a90d87", preview: .uniqueIcon(named: "monster_flowery")),
                                .init(effectName: "ConfusedRabbit_fe3416f", preview: .uniqueIcon(named: "confused_rabbit")),
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Foreground effects",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Retrowave_0a452ba", preview: .uniqueIcon(named: "retrowave")),
//                                .init(effectName: "", preview: .uniqueIcon(named: "")),
                            ]
                        )
                    ]
                )
            ]
        case .faceTracking:
            return [
                EffectsCategory(
                    title: "Landmarks",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "DebugFRX_d4407a6", preview: .none),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Distance to Phone",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "test_Ruler_d31c700", preview: .none, pollingMethod: .distanceMeasurement),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Analytics",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Skin Color",
                            effectsList: [
                                .init(effect: .skinColor),
                            ]
                        ),
                        EffectsGroup(
                            title: "Hair Color",
                            effectsList: [
                                .init(effect: .hairColor),
                            ]
                        ),
                        EffectsGroup(
                            title: "Glasses detector",
                            effectsList: [
                                .init(effectName: "Glasses_detector_2ef586e", preview: .none, pollingMethod: .glassesDetection),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Background/Foreground",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Background",
                            effectsList: [
                                .init(effectName: "BG_0a35678", preview: .none),
                            ]
                        ),
                        EffectsGroup(
                            title: "Foreground",
                            effectsList: [
                                .init(effectName: "FG_0a35678", preview: .none),
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Body segmentation",
                    effectsGroups: [
                        EffectsGroup(
                            title: "Body separation",
                            effectsList: [
                                .init(effectName: "Full_Body_490003b", preview: .none),
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Lips segmentation",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Lips_a8b6c77", preview: .none),
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Eye segmentation",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Eye_lenses_c83b3ae", preview: .none),
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Hair segmentation",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Hair_012f275", preview: .none),
                            ]
                        )
                    ]
                ),
                EffectsCategory(
                    title: "Skin Segmentation",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Skin_000c2ae", preview: .none),
                            ]
                        )
                    ]
                )
            ]
        case .arGames:
            return [
                EffectsCategory(
                    title: "Your Animal",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "WhatAnimalAreYou_ec80631", preview: .none),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Bunny Quiz",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "WhatBunnyAreYou_0779a09", preview: .none),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Flappy Plane",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "FlappyPlane_mouth_db959f8", preview: .none, screenScaling: .FitScreen),
                            ]
                        ),
                    ]
                ),
            ]
        case .avatar:
            return [
                EffectsCategory(
                    title: "Rabbit",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "ActionunitsRabbit_647d9e1", preview: .none),
                            ]
                        ),
                    ]
                ),
                EffectsCategory(
                    title: "Hades",
                    effectsGroups: [
                        EffectsGroup(
                            title: "",
                            effectsList: [
                                .init(effectName: "Hades_6f85dc8", preview: .none),
                            ]
                        ),
                    ]
                )
            ]
        }
    }
}
