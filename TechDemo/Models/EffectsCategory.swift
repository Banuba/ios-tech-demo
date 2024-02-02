//
//  EffectsCategory.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 03.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

struct EffectsCategory: Equatable {
    let title: String
    let effectsGroups: [EffectsGroup]
    let deepLinkId: String?
    
    init(title: String, effectsGroups: [EffectsGroup], deepLinkId: String? = nil) {
        self.title = title
        self.effectsGroups = effectsGroups
        self.deepLinkId = deepLinkId
    }
}
