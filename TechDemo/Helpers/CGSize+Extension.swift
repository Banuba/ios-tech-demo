//
//  CGSize+Extension.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 07.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

extension CGSize {
    func rounded() -> CGSize {
        return .init(width: width.rounded(), height: height.rounded())
    }
}

