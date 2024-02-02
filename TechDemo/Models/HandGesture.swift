//
//  HandGesture.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 21.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

enum HandGesture: String {
    case noGesture = "No Gesture"
    case like = "Like"
    case ok = "Ok"
    case rock = "Rock"
    case victory = "Victory"
    case palm = "Palm"
    
    var emoji: String {
        switch self {
        case .noGesture: return ""
        case .like: return "👍"
        case .ok: return "👌"
        case .rock: return "🤘"
        case .victory: return "✌️"
        case .palm: return "✋"
        }
    }
    
    var title: String {
        switch self {
        case .noGesture: return "No Gesture"
        case .like: return "Like"
        case .ok: return "Ok"
        case .rock: return "Rock"
        case .victory: return "Victory"
        case .palm: return "Palm"
        }
    }
}
